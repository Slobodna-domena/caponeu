class AddPriorityToNews < ActiveRecord::Migration[7.0]
  def change
    add_column :news, :priority, :integer, :default => 0
  end
end
