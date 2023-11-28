require 'net/http'
require 'json'

class ChatResponseService
  class << self
    def call(message_body, conversation_id)
      conversation = Conversation.includes(:profile).find(conversation_id)
      payload = create_payload
      payload = update_payload(payload, conversation, message_body)
      payload = add_history_to_payload(payload, conversation)
      get_response(payload, conversation)
    end

    private

    def update_payload(payload, conversation, message_body)
      profile = conversation.profile
      payload.merge({
        "your_name": conversation.user_name,
        "user_input": message_body,
        "name1": conversation.user_name,
        "name2": profile.name,
        "greeting": "hello, how are you?",
        "context": "witty, #{profile.gender}, model, athletic, urban indian, #{profile.category}",
        "character": "Example"
      })
    end

    def create_payload
      Marshal.load(Marshal.dump(API_PAYLOAD_STRUCTURE))
    end

    def add_history_to_payload(payload, conversation)
      previous_message = ""
      conversation.messages.order(:created_at).each_with_index do |message, index|
        if message.messager_type == "ai"
        # If it's the first message from the assistant, we add the LLM format required
          if index == 0
            payload["history"]["internal"] << ["<|BEGIN-VISIBLE-CHAT|>", message.body] if index == 0
            payload["history"]["visible"] << ["", message.body]
            else
              payload["history"]["internal"] << [previous_message, message.body]
              payload["history"]["visible"] << [previous_message, message.body]
            end

           previous_message = ""
        else
          previous_message = message.body
        end
      end
      payload
    end

    def get_response(payload, conversation)
      url = URI.parse(get_server_url)
      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Post.new(url.path, {'Content-Type' => 'application/json'})
      request.body = payload.to_json
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        # Parse the JSON response
        response_json = JSON.parse(response.body)
        
        conversation.messages.create(
          body: response_json['results'][0]['history']['internal'].last.last,
          messager_type: 'ai'
        )
      else
        puts "Error: #{response.code} - #{response.message}"
      end
    end

    def get_server_url
      LoadbalancerService.call
    end
  end
end
