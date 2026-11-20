ActiveAdmin.register Geo do

  actions :all, :except => :show
  permit_params :latitude, :longitude, :polygon, :title

  scope :all, default: true
  scope("No lat/lon", :without_coordinates)

  filter :title

  index do
    column :title do |geo|
      if geo.mappable? || geo.polygon.present?
        geo.title
      else
        span geo.title
        status_tag "no lat/lon", class: "warning"
      end
    end
    actions
  end

  form do |f|
    f.inputs do
      if f.object.persisted? && !f.object.mappable? && f.object.polygon.blank?
        para "Warning: this location has no latitude/longitude or polygon, so it can't be shown on the map.", style: "color:#b45309;font-weight:bold"
      end
      f.input :title
      f.input :latitude, label: "Latitude"
      f.input :longitude, label: "Longitude"
      f.input :polygon, as: :string, label: "Polygon"
    end
    f.submit
  end
end
