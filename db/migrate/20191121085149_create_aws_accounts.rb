class CreateAwsAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :aws_accounts do |t|
      t.string :name, null: false
      t.string :description
      t.string :account_id, null: false
      t.string :external_id, null: false
      t.string :role_name, null: false
      t.references :organization, foreign_key: true
      t.timestamps
    end
    add_index :aws_accounts, :name, unique: true
    add_index :aws_accounts, :account_id, unique: true
  end
end
