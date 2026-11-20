ActiveAdmin.register Person do

  actions :all, :except => :show
  permit_params :first_name, :last_name, :birth, :death, :place_of_birth, :place_of_death, :title, :photo, :bio, :photo_source,
                person_type_ids: [], novel_ids: [], material_ids: [], organization_ids: [], event_ids: []
  menu priority: 3

  filter :first_name
  filter :last_name
  filter :birth
  filter :death
  filter :place
  filter :person_types, as: :select, collection: PersonType.all.map{|b| [b.label,b.id]}

  index do
    column :first_name
    column :last_name
    column :person_types do |p|
      p.person_types.pluck(:label)
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :first_name, as: :string
      f.input :last_name, as: :string
      f.input :bio, input_html: {class: "editor_minimal"}
      f.input :photo, hint: f.object.photo.url ? image_tag(f.object.photo.compact.url) : nil
      f.input :photo_source, input_html: {class: "editor_minimal"}
      f.input :birth, as: :datepicker, datepicker_options: { changeYear: true, changeMonth: true }
      f.input :death, as: :datepicker, datepicker_options: { changeYear: true, changeMonth: true }
      f.input :place_of_birth, as: :string
      f.input :place_of_death, as: :string
      f.input :person_types, as: :select, collection: PersonType.all.map{|b| [b.label,b.id]}.sort, input_html: { class: 'selectize'}
      f.inputs "Related content" do
        f.input :novels, collection: Novel.all.map{|b| [b.title,b.id]}.sort, input_html: { class: 'selectize'}
        f.input :events, collection: Event.all.map{|b| [b.title,b.id]}.sort, input_html: { class: 'selectize'}
        f.input :materials, collection: Material.all.map{|b| [b.title,b.id]}.sort, input_html: { class: 'selectize'}
        f.input :organizations, collection: Organization.all.map{|b| [b.label,b.id]}.sort, input_html: { class: 'selectize'}
      end
    end
    f.submit
  end
end
