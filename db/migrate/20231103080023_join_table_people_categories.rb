class JoinTablePeopleCategories < ActiveRecord::Migration[7.0]
  def change
    create_join_table :people, :categories
  end
end
