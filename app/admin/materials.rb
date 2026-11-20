ActiveAdmin.register Material do
  extend ActiveAdmin::SharedModule

  actions :all, :except => :show
  permit_params :title, :summary, :content, :external_document, :public, :produced_by_caponeu, :copyright_notice, :authors, :published_until,
                author_ids: [], organization_ids: [], event_ids: [], keyword_ids: [], geo_ids: [],
                person_ids: [], attachments: [], novel_ids: [], material_type_ids: []

  menu priority: 5

  filter :title
  filter :summary
  filter :content
  filter :external_document
  filter :public
  filter :produced_by_caponeu
  filter :material_type
  filter :copyright_notice

  index do
    column :title
    column :public
    column :produced_by_caponeu
    column :material_type
    actions
  end

  form html: { multipart: true } do |f|
    f.object.public = true if f.object.new_record?
    f.inputs do
      f.input :title
      f.input :summary, input_html: { class: "editor_minimal" }
      f.input :content, input_html: { class: "editor" }
      #f.input :external_document
    end
    f.inputs do
      f.input :published_until, as: :datepicker
      f.input :public
      f.input :produced_by_caponeu
    end
    f.inputs do
      f.input :authors, collection: Person.all.map { |b| [b.full_name, b.id] }, input_html: { class: "selectize" }
      f.input :attachments, :as => :file, :input_html => { :multiple => true },
                            hint: f.object.attachments.any? ? f.object.attachments.map { |a| link_to(a.identifier, a.url, target: "_blank") }.join("<br>").html_safe : "To add more than one press SHIFT while adding files."
      f.input :material_types, collection: MaterialType.all.map { |b| [b.label, b.id] }, input_html: { class: "selectize" }
      f.input :copyright_notice
      f.input :novels, collection: Novel.all.map { |b| [b.title, b.id] }, input_html: { class: "selectize" }
      f.inputs "Related content" do
        f.input :organizations, collection: Organization.publishers.map { |b| [b.label, b.id] }.sort, input_html: { class: "selectize" }, label: "Publishers"
        f.input :events, collection: Event.all.map { |b| [b.title, b.id] }.sort, input_html: { class: "selectize" }
        f.input :keywords, collection: Keyword.all.map { |b| [b.label, b.id] }.sort, input_html: { class: "selectize-with-add-new" }
        f.input :people, collection: Person.other.map { |b| [b.full_name, b.id] }.sort, input_html: { class: "selectize" }
        f.input :geos, label: "Geographical points or zones", collection: Geo.all.map { |b| [b.title, b.id] }.sort, input_html: { class: "selectize" }
      end
    end
    f.submit
  end
end
