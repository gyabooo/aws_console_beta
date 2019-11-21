class CreateAwsAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :aws_accounts do |t|
      t.string :name, null: false
      t.string :description
      t.string :account_id, null: false
      t.references :organization
      t.timestamps
    end
  end
end
