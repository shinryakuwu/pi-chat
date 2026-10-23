class AddChatMessageHistoryIndex < ActiveRecord::Migration[8.1]
  def up
    add_index :messages,
      [ :chat_id, :created_at, :id ],
      name: "index_messages_on_chat_id_and_created_at_and_id"

    remove_index :messages,
      name: "index_messages_on_chat_id"
  end

  def down
    add_index :messages,
      :chat_id,
      name: "index_messages_on_chat_id"

    remove_index :messages,
      name: "index_messages_on_chat_id_and_created_at_and_id"
  end
end
