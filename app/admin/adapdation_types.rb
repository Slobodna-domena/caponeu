ActiveAdmin.register AdaptationType do
  actions :all, :except => :show
  menu parent: "Settings"

  permit_params :label

  index do
    column :label
    actions
  end

  filter :label

  form do |f|
    f.inputs do
      f.input :label
    end
    f.actions
  end
end
