class ConversationsController < ApplicationController

  def show
    @profile = Profile.find(params[:id])
    @conversation = Conversation.find_or_create_by(profile_id: params[:id], user_name: 'john doe')
    @messages = @conversation.messages.order('created_at desc')
  end
end
