class CreateVoicecomMessages < ActiveRecord::Migration
  def change
    create_table :voicecom_messages do |t|
      t.string :number, null: false
      t.string :text, null: false
      t.integer :operator
      t.integer :validity
      t.integer :priority
      t.text :hlr
      t.text :request
      t.text :response
      t.datetime :response_received_at
      t.integer :status, default: 0 # 0 - pending, 1 - success, 2 - failed

      #t.text :delivery_request
      #t.text :delivery_response
      #t.datetime :delivery_response_received_at
      #t.integer :delivery_status, default: 0 # 0 - pending, 1 - success, 2 - failed

      t.boolean :delivered, default: false

      t.timestamps
    end

    add_index :voicecom_messages, :number
    add_index :voicecom_messages, :operator
    add_index :voicecom_messages, :status
    add_index :voicecom_messages, :delivered
  end
end
