ActiveAdmin.register Keyword do
  actions :all, :except => :show
  permit_params :label, :parent_id, :short_description

  filter :label

  # parent_ids = Keyword.pluck(:parent_id).uniq
  # scope "All" do
  #   Keyword.all
  # end

  # parent_ids.each do |k|
  #   if k
  #     scope Keyword.find(k).label do
  #       Keyword.where(parent_id: k)
  #     end
  #   else
  #     scope "Parentless" do
  #       Keyword.where(parent_id: nil)
  #     end
  #   end
  # end

  index do
    column :label
    column :parent_id do |k|
      if k.parent_id.present?
        k = Keyword.find_by_id(k.parent_id)
        k ? k.label : ""
      end
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :label, label: "Keyword"
      f.input :short_description
      f.input :parent_id, as: :select, collection: Keyword.all.map { |b| [b.label, b.id] }, input_html: { class: "selectize" }
    end
    f.submit
  end
end
