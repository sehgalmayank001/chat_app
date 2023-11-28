class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :conversation

  delegate :profile, to: :conversation
  enum messager_type: { user: 0, ai: 1}

  after_create_commit -> { broadcast_message }

  private

  def broadcast_message
    broadcast_prepend_to(
      "#{dom_id(conversation)}_messages",
      partial: 'messages/message',
      locals: { message: self, scroll_to: true, profile:  },
      target: "#{dom_id(conversation)}_messages"
    )
  end
end
