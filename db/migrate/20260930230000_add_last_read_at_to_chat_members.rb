class AddLastReadAtToChatMembers < ActiveRecord::Migration[8.1]
  def up
    add_column :chat_members, :last_read_at, :datetime
    execute "UPDATE chat_members SET last_read_at = CURRENT_TIMESTAMP"
  end

  def down
    remove_column :chat_members, :last_read_at
  end
end
