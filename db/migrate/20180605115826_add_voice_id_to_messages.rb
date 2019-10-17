class AddVoiceIdToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :voice_id, :string
  end
end
