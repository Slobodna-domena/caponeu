namespace :migrations do
  task add_geo_to_novels: [:environment] do
    Novel.all.each do |n|
      n.place_of_origin_id = Geo.first.id if n.place_of_origin_id.nil? and n.geos.any?
      n.save!
    end
  end
end
