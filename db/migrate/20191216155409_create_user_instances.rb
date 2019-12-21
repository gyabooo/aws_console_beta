class CreateUserInstances < ActiveRecord::Migration[5.2]
  def change
    create_table :user_instances do |t|
      t.references :user, optional: true
      t.references :instance, optional: true
      t.timestamps
    end
  end
end
