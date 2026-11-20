ActiveAdmin.register Edition do


  actions :all, :except => :show
  permit_params :novel_id, :title, :language_id, :publisher_id, :from_year,
                :isbn, :place_of_publication, :pof_poi_id, :cover,
                organization_ids: [], translator_ids: []
  config.sort_order = "title_asc"

  menu false

  filter :title

  index do
    column :title
    column :from_year
    column :isbn
    column :place_of_publication
    actions
  end

  form do |f|
    f.inputs do
      f.input :novel_id, as: :select, collection: Novel.all.map{|b| [b.title,b.id]}.sort, input_html: { class: 'selectize'}
      f.input :title
      f.input :language_id, as: :select, collection: Language.all.map{|b| [b.label,b.id]}.sort, input_html: { class: 'selectize'}
      f.input :publisher_id, as: :select, input_html: { class: 'selectize'}, collection: Organization.all.filter_map { |b|
        next if b.organization_types.all? { _1.label != "Publisher" }
        [b.label,b.id]
      }.sort
      f.input :from_year
      f.input :translators, as: :select, multiple: true, collection: Person.all.map{|b| [b.full_name,b.id]}.sort, input_html: { class: 'selectize'}
      f.input :isbn
      f.input :place_of_publication_id, collection: Geos.all.map{|b| [b.title, b.id]}.sort, input_html: { class: 'selectize'}
      f.input :pof_poi_id, as: :select, collection: Person.all.map{|b| [b.full_name,b.id]}.sort, input_html: { class: 'selectize'}
      f.input :cover, hint: f.object.cover.url ? image_tag(f.object.cover.book.url) : nil
      f.input :organizations, as: :select, collection: Organization.all.map{|b| [b.label,b.id]}.sort, input_html: { class: 'selectize'}
    end
    f.submit
  end

end
