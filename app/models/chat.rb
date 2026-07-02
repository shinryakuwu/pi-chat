class Chat < ApplicationRecord
  enum :chat_type, { private: 0, group: 1 }

  has_many :chat_members
  has_many :messages
end
