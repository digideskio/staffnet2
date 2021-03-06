class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :donation_id
      t.integer :payment_profile_id
      t.integer :deposit_batch_id
      t.string  :legacy_id, :default => ''
      t.string  :cim_transaction_id, :default => ''
      t.string  :cim_auth_code, :default => ''
      t.date    :deposited_at
      t.string  :payment_type, :default => ''
      t.boolean :captured, :default => false
      t.boolean :processed, :default => false
      t.decimal :amount, :scale => 2, :precision=> 8, :default => 0
      t.text    :notes, :default => ''

      t.timestamps
    end
    add_index :payments, :cim_auth_code
    add_index :payments, :payment_profile_id
    add_index :payments, :donation_id
    add_index :payments, :cim_transaction_id
    add_index :payments, :deposit_batch_id
  end
end
