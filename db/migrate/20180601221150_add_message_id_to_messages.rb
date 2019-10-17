class AddMessageIdToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :message_id, :integer
  end
end
