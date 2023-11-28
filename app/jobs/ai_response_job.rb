class AiResponseJob < ApplicationJob
  queue_as :default

  def perform(message_body, conversation_id)
    ChatResponseService.call(message_body, conversation_id)
  end
end
