class MessagesController < ApplicationController

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.create!(message_params.merge(messager_type: 'user'))

    AiResponseJob.perform_later(message_params[:body], @conversation.id)
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end