class AddCensorshipStatusToNovels < ActiveRecord::Migration[7.0]
  def change
    add_column :novels, :censorship_status, :string
  end
end
