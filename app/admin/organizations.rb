ActiveAdmin.register Organization do
  actions :all, :except => :show
  permit_params :label, :organization_types_id, :logo, :subtitle, :sort,
                organization_type_ids: [], person_ids: [], edition_ids: [], event_ids: [], geo_ids: []

  menu priority: 6

  filter :label
  filter :organization_types_id, as: :select, collection: OrganizationType.all.map { |b| [b.label, b.id] }

  index do
    column :label
    column :added_by do |id|
      id.added_by
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :label, as: :string
      f.input :subtitle, hint: "Only for organization on About page"
      f.input :sort, hint: "Only for organization on About page"
      f.input :organization_types, as: :select, collection: OrganizationType.all.map { |b| [b.label, b.id] }, input_html: { class: "selectize" }
      f.input :logo, hint: f.object.logo.url ? image_tag(f.object.logo.compact.url) : nil
      f.input :geos, label: "Geographical points or zones", collection: Geo.all.map { |b| [b.title, b.id] }.sort, input_html: { class: "selectize" }

      # f.inputs "Related content" do
      #   f.input :people, as: :select, collection: Person.all.map{|b| [b.full_name,b.id]}, input_html: { class: 'selectize'}
      #   #f.input :editions, as: :select, collection: Edition.all.map{|b| [b.title,b.id]}, input_html: { class: 'selectize'}
      #   f.input :events, as: :select, collection: Event.all.map{|b| [b.title,b.id]}, input_html: { class: 'selectize'}
      # end
    end
    f.submit
  end
end
