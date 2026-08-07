class ChatMember < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  enum :role, { owner: 0, member: 1, moderator: 2 }
  enum :status, { active: 0, left: 1, banned: 2 }
end
