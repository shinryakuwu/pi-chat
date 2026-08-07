class User < ApplicationRecord
  has_secure_password

  has_many :chat_members
  has_many :chats, through: :chat_members
  has_many :messages, foreign_key: :author_id

  validates :username, presence: true

  def to_param
    username
  end
end
