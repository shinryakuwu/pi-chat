class Chat < ApplicationRecord
  MESSAGE_PAGE_SIZE = 40

  enum :chat_type, { direct_chat: 0, group_chat: 1, self_chat: 2 }

  has_many :chat_members, dependent: :destroy
  has_many :users, through: :chat_members
  has_many :messages, dependent: :destroy
  has_one :last_message, -> { order(created_at: :desc) }, class_name: "Message"

  has_one_attached :cover

  accepts_nested_attributes_for :chat_members

  validate :members_count

  def recipient(current_user)
    users.find { |user| user.id != current_user.id }
  end

  def unread_count(current_user)
    chat_member = chat_members.find_by!(user_id: current_user.id)
    unread_messages = messages.where.not(author_id: current_user.id)
    unread_messages = unread_messages.where("created_at > ?", chat_member.last_read_at) if chat_member.last_read_at
    unread_messages.count
  end

  def latest_messages_page
    records = messages
      .includes(
        drawing_attachment: :blob,
        sticker: { sticker_image_attachment: :blob },
        author: { profile_picture_attachment: :blob }
      )
      .order(created_at: :desc, id: :desc)
      .limit(MESSAGE_PAGE_SIZE + 1) # using the extra record to determine whether another page exists
      .to_a

    has_older_messages = records.length > MESSAGE_PAGE_SIZE

    [
      records.first(MESSAGE_PAGE_SIZE).reverse,
      has_older_messages
    ]
  end

  private

  def members_count
    case chat_type
    when "direct_chat"
      errors.add(:base, "Direct chat can only have two members") unless chat_members.size == 2
    when "self_chat"
      errors.add(:base, "Self chat can only have one member") unless chat_members.size == 1
    end
  end
end
