class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :title
      t.text :sms_content
      t.boolean :has_voice_content
      t.boolean :has_sms_content
      t.integer :language_id
      t.integer :audio_file_id

      t.timestamps
    end
  end
end
