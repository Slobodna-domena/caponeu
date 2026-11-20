class CreateMaterialsNovelsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :materials, :novels
  end
end
