class Message < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :chat
  belongs_to :replied_message, class_name: "Message", optional: true
end
