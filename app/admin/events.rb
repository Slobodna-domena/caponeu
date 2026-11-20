ActiveAdmin.register Event do
  extend ActiveAdmin::SharedModule

  menu priority: 2

  actions :all, :except => :show

  permit_params :title, :started, :ended, :content, :main_event_id, :short_summary, :hide_from_timeline,
                organization_ids: [], novel_ids: [], keyword_ids: [], geo_ids: [],
                event_type_ids: [], person_ids: [],
                attachments_attributes: [:_destroy, :id, :file, :title, :event_id, :sort],
                galleries_attributes: [:_destroy, :id, :image, :video, :event_id, :caption]

  filter :title
  filter :started
  filter :ended
  filter :event_types_id, as: :select, collection: EventType.all.map { |b| [b.label, b.id] }

  index do
    column :title
    column :started
    column :ended
    actions
  end

  form do |f|
    f.inputs "About the event" do
      f.input :title, as: :string, label: "Title"
      f.input :started, as: :date_select, label: "Started", as: :datepicker
      f.input :ended, as: :date_select, label: "Ended", as: :datepicker
      f.input :short_summary, input_html: { class: "editor_minimal" }, label: "Short summary"
      f.input :content, input_html: { class: "editor" }
      f.input :event_types, collection: EventType.all.map { |b| [b.label, b.id] }, input_html: { class: "selectize" }
      f.input :geos, collection: Geo.all.map { |b| [b.title, b.id] }, input_html: { class: "selectize" }
      f.input :hide_from_timeline
    end
    f.inputs "Related content" do
      f.input :organizations, collection: Organization.all.map { |b| [b.label, b.id] }, input_html: { class: "selectize" }
      f.input :keywords, collection: Keyword.all.map { |b| [b.label, b.id] }, input_html: { class: "selectize-with-add-new" }
      f.input :novels, collection: Novel.all.map { |b| [b.title, b.id] }, input_html: { class: "selectize" }
      f.input :people, collection: Person.all.map { |b| [b.full_name, b.id] }, input_html: { class: "selectize" }
      f.input :main_event, collection: Event.all.map { |b| [b.title, b.id] }, input_html: { class: "selectize" }, label: "Main event"
    end

    f.inputs "Attachments" do
      f.has_many :attachments, allow_destroy: true do |g|
        g.input :file, hint: g.object.file.url ? link_to(g.object.filename, g.object.file.url) : nil
        g.input :title
        g.input :sort
      end
    end

    f.inputs "Gallery" do
      #f.input :gallery_title
      f.has_many :galleries, allow_destroy: true do |g|
        g.input :image, hint: g.object.image.url ? image_tag(g.object.image.compact.url) : nil
        g.input :video, hint: "YouTube video ID"
        g.input :caption
      end
    end

    f.submit
  end
end
