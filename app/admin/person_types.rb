ActiveAdmin.register PersonType do
  actions :all, :except => :show
  menu parent: "Settings"

  permit_params :label, :hide_from_people_directory

  config.sort_order = "label_asc"

  filter :label

  index do
    column :label
    column 'ONLY FOR "ABOUT CAPONEU"', :hide_from_people_directory
    actions
  end

  form do |f|
    f.inputs do
      f.input :label
      f.input :hide_from_people_directory, label: 'ONLY FOR "ABOUT CAPONEU"'
    end
    f.submit
  end
end
