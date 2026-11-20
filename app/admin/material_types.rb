ActiveAdmin.register MaterialType do

  actions :all, :except => :show
  menu parent: "Settings"
  permit_params :label
  config.sort_order = "label_asc"

  filter :label

  index do
    column :label
    actions
  end

  form do |f|
    f.inputs do
      f.input :label
    end
    f.submit
  end
end
