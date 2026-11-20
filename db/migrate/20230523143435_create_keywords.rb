class CreateKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.string :label
      t.bigint :parent_id
    end
  end
end
