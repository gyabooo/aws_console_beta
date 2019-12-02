class CreateOrganizationUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :organization_users do |t|
      t.references :user, optional: true
      t.references :organization, optional: true
      t.timestamps
    end
  end
end
