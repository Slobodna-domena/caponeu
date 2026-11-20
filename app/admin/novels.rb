ActiveAdmin.register Novel do
  extend ActiveAdmin::SharedModule

  actions :all, :except => :show
  permit_params :title, :english_title, :from_year, :to_year, :portrait_title, :portrait_summary, :summary, :isbn,
                :authors, :cover, :place_of_origin_id, :thematic_collections, :cover_source, :censorship_status, :further_reading,
                editions_attributes: [:id, :novel_id, :title, :publisher_id, :from_year, :censorship_status,
                                      :isbn, :place_of_publication_id, :_destroy,
                                      organization_ids: [], translator_ids: []],
                portrait_author_ids: [], author_ids: [], event_ids: [], keyword_ids: [], geo_ids: [], language_ids: [],
                thematic_collection_ids: [],
                person_ids: [], organization_ids: [], category_ids: [],
                adaptations_attributes: [:id, :title, :year, :adaptation_type_id, :description, :_destroy]
  menu priority: 0

  filter :title
  filter :english_title
  filter :from_year
  filter :portrait_summary
  filter :summary
  filter :languages, as: :select, collection: -> { Language.order(:label).pluck(:label, :id) }

  index do
    column :title
    column :from_year
    column :place_of_origin
    column :languages do |novel|
      if novel.languages.any?
        novel.languages.map(&:label).join(', ')
      else
        "Unspecified"
      end
    end
    actions
  end

  form do |f|
    f.inputs "About the novel" do
      f.input :english_title, hint: "This is primary title"
      f.input :title
      f.input :cover, hint: f.object.cover.url ? image_tag(f.object.cover.book.url) : nil
      f.input :cover_source, input_html: { class: "editor_minimal" }, label: "Cover image source"
      f.input :authors, collection: Person.all_authors.map { |b| [b.full_name, b.id] }.sort, input_html: { class: "selectize" }
      f.input :from_year
      f.input :to_year
      f.input :isbn
      f.input :place_of_origin_id, as: :select, collection: Geo.all.map { |b| [b.title, b.id] }.sort, input_html: { class: "selectize" }
      f.input :languages, collection: Language.all.map { |b| [b.label, b.id] }.sort, input_html: { class: "selectize" }
      f.input :censorship_status, as: :select, collection: ["Not censored", "Censored before publication", "Censored after publication", "Published in censored form"]
    end
    f.inputs "PN Portrait" do
      f.input :portrait_summary, input_html: { class: "editor_minimal" }
      f.input :summary, input_html: { class: "editor" }
      f.input :portrait_authors, collection: Person.all_portrait_authors.map { |b| [b.full_name, b.id] }.sort, input_html: { class: "selectize" }
      f.input :further_reading, input_html: { class: "editor_minimal" }
    end
    f.inputs "Related content" do
      f.input :organizations, collection: Organization.all.map { |b| [b.label, b.id] }.sort, input_html: { class: "selectize" }
      f.input :events, collection: Event.all.map { |b| [b.title, b.id] }.sort, input_html: { class: "selectize" }
      f.input :keywords, collection: Keyword.all.map { |b| [b.label, b.id] }.sort, input_html: { class: "selectize-with-add-new" }
      f.input :people, collection: Person.other.map { |b| [b.full_name, b.id] }.sort, input_html: { class: "selectize" }
      f.input :categories, collection: Category.all.map { |b| [b.label, b.id] }.sort, input_html: { class: "selectize-with-add-new" }
      f.input :geos, label: "Geographical points or zones", collection: Geo.all.map { |b| [b.title, b.id] }.sort, input_html: { class: "selectize" }
      #f.input :thematic_collections, collection: ThematicCollection.all.map { |b| [b.title, b.id] }, input_html: { class: "selectize" }
    end
    f.inputs "Editions" do
      f.has_many :editions,
                 allow_destroy: true,
                 remove_record: "Remove Edition" do |g|
        g.object.novel_id ||= f.object.id
        g.input :novel_id, as: :hidden
        g.input :title
        g.input :language_id, as: :select, input_html: { class: "selectize" }, collection: Language.all.map { |b| [b.label, b.id] }.sort
        g.input :publisher_id, as: :select, input_html: { class: "selectize" }, collection: Organization.publishers.filter_map { |b| [b.label, b.id] }.sort
        g.input :from_year
        g.input :translators, as: :select, multiple: true, collection: Person.all.filter_map { |b| [b.full_name, b.id] if b.person_types.any? { |c| c.label == "Translator" } }.sort, input_html: { class: "selectize" }
        g.input :isbn
        g.input :place_of_publication_id, as: :select, collection: Geo.all.map { |b| [b.title, b.id] }.sort, input_html: { class: "selectize" }
        #g.input :pof_poi_id, as: :select, collection: Person.all.map{|b| [b.full_name,b.id]}, input_html: { class: 'selectize'}, label: "Person of interest"
        #g.input :cover, hint: g.object.cover.url ? image_tag(g.object.cover.book.url) : nil
        #g.input :cover_source, input_html: {class: "editor_minimal"}, label: "Cover image source"
      end
    end
    f.inputs "Adaptations" do
      f.has_many :adaptations,
                 allow_destroy: true,
                 remove_record: "Remove Adaptation" do |g|
        g.object.novel_id ||= f.object.id
        g.input :novel_id, as: :hidden
        g.input :title
        g.input :year
        g.input :adaptation_type_id, as: :select, input_html: { class: "selectize" }, collection: AdaptationType.all.map { |b| [b.label, b.id] }.sort
        g.input :description, input_html: { class: "editor_minimal" }
      end
    end
    f.submit
  end
end
