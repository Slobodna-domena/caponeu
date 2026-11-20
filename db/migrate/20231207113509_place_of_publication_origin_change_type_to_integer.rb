class PlaceOfPublicationOriginChangeTypeToInteger < ActiveRecord::Migration[7.0]
  def change
    remove_column :editions, :place_of_publication
    remove_column :novels, :place_of_origin

    add_column :editions, :place_of_publication_id, :integer
    add_column :novels, :place_of_origin_id, :integer
  end
end
