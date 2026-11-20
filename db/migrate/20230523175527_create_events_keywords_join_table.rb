class CreateEventsKeywordsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :events, :keywords
  end
end
