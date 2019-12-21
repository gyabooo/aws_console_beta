class CreateInstances < ActiveRecord::Migration[5.2]
  def change
    create_table :instances do |t|
      t.string :instance_id, null: false
      t.string :type
      t.references :aws_account, foreign_key: true
      t.timestamps
    end
    add_index :instances, :instance_id, unique: true
  end
end
