class CreateThematicCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :thematic_collections do |t|
      t.string :title
      t.text :summary
      t.binary :cover

    end
  end
end
