ActiveAdmin.register ThematicCollection do
  actions :all, :except => :show
  permit_params :title, :summary, :active, :organization_id,
                audience_ids: [], keyword_ids: [], person_ids: [],
                thematic_sections_attributes: [:id, :thematic_collection_id, :title, :summary, :sort, :_destroy, :related_model,
                                               novel_ids: [], material_ids: [], person_ids: [], event_ids: [], keyword_ids: []]

  config.sort_order = "title_asc"

  menu priority: 4

  filter :title
  filter :summary

  index do
    column :title
    column :active
    actions
  end

  form do |f|
    f.inputs do
      f.input :title, as: :string
      f.input :summary, as: :text
      f.input :audiences, collection: Audience.all.map { |b| [b.label, b.id] }, input_html: { class: "selectize" }
      f.input :keywords, collection: Keyword.all.map { |b| [b.label, b.id] }, input_html: { class: "selectize-with-add-new" }
      f.input :people, label: "Curated by", collection: PersonType.find_by_label("Caponeu Team Member").people.map { |b| [b.full_name, b.id] }, input_html: { class: "selectize" }
      f.input :organization, collection: Organization.all.map { |b| [b.label, b.id] }, input_html: { class: "selectize" }
      f.input :active
    end
    f.inputs "Related content" do
      f.has_many :thematic_sections, allow_destroy: true do |t|
        t.input :title, as: :string
        t.input :sort, as: :number
        t.input :summary, as: :text
        t.input :related_model, as: :select, collection: ["Novels", "Materials", "People", "Events", "Topics"]
        if t.object.related_model == "Novels"
          t.input :novels, collection: Novel.all.map { |b| [b.title, b.id] }, input_html: { class: "selectize" }
        end
        if t.object.related_model == "Materials"
          t.input :materials, collection: Material.all.map { |b| [b.title, b.id] }, input_html: { class: "selectize" }
        end
        if t.object.related_model == "People"
          t.input :people, collection: Person.not_caponeu_team.map { |b| [b.full_name, b.id] }, input_html: { class: "selectize" }
        end
        if t.object.related_model == "Events"
          t.input :events, collection: Event.all.map { |b| [b.title, b.id] }, input_html: { class: "selectize" }
        end
        if t.object.related_model == "Topics"
          t.input :keywords, collection: Keyword.all.map { |b| [b.label, b.id] }, input_html: { class: "selectize" }
        end
      end
    end
    f.submit
  end
end
