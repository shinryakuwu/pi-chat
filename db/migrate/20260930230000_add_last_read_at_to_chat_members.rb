class AddLastReadAtToChatMembers < ActiveRecord::Migration[8.1]
  def change
    add_column :chat_members, :last_read_at, :datetime
    execute "UPDATE chat_members SET last_read_at = CURRENT_TIMESTAMP"
  end
end
p