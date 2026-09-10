class CreateStickers < ActiveRecord::Migration[8.1]
  def change
    create_table :stickers do |t|
      t.string :name

      t.timestamps
    end

    add_reference :messages, :sticker, null: true, foreign_key: true
    add_column :messages, :message_type, :integer, default: 0, null: false
  end
end
