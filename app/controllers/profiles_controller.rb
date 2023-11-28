class ProfilesController < ApplicationController

  def index
    @search = Profile.ransack(params[:q])
    @profiles = @search.result.page(page_number).per(per_page_value)
  end

  def conversation
    @conversation = Conversation.find_or_create_by(profile_id: params[:id], user_name: 'john doe')
    redirect_to conversation_path(@conversation)
  end
end
