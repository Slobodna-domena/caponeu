class CreateEventsOrganizationJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table "events_organizations" do |t|
      t.belongs_to :event
      t.belongs_to :organization
    end
  end
end
