class CreateOrganizationTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :organization_types do |t|
      t.string :type

      t.timestamps
    end
  end
end
