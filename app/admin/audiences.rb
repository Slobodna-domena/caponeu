ActiveAdmin.register Audience do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :label
  #
  # or
  #
  # permit_params do
  #   permitted = [:label]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

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
