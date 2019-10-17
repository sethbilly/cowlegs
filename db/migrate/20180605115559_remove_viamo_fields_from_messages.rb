class RemoveViamoFieldsFromMessages < ActiveRecord::Migration[5.1]
  def change
    remove_column :messages, :sms_content, :string
    remove_column :messages, :has_voice_content, :string
    remove_column :messages, :has_sms_content, :string
    remove_column :messages, :audio_file_id, :string
    remove_column :messages, :language_id, :string
  end
end
