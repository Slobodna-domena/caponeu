ActiveAdmin.register Version do
  menu label: "Versions", priority: 99

  actions :index, :show

  index do
    column :id
    column :item do |version|
      if version.item_type && version.item_id
        begin
          item = version.item_type.constantize.find_by(id: version.item_id)
          if item
            link_to "#{version.item_type} ##{version.item_id}", send("edit_admin_#{version.item_type.underscore}_path", item)
          else
            "#{version.item_type} ##{version.item_id} (deleted)"
          end
        rescue
          "#{version.item_type} ##{version.item_id}"
        end
      end
    end
    column :event
    column :user do |version|
      if version.whodunnit
        user = AdminUser.find_by(id: version.whodunnit)
        user ? auto_link(user) : version.whodunnit
      end
    end
    column :created_at
    column :show do |version|
      link_to "Show", admin_version_path(version)
    end
  end

  show do
    attributes_table do
      row :changes do |version|
        div do
          YAML.safe_load(version.object_changes, permitted_classes: [ActiveSupport::TimeWithZone, ActiveSupport::TimeZone, Time], aliases: true).each do |key, (before, after)|
            next if ["updated_at", "created_at", "id"].include?(key)
            table class: "version-table" do
              thead do
                tr do
                  th "Field", style: "width: 15%;"
                  th "Before", style: "width: 38%;"
                  th "After", style: "width: 38%;"
                end
              end
              tbody do
                tr do
                  td key
                  td before
                  td after
                end
              end
            end
          end
        end
      end
      row :user do |version|
        if version.whodunnit
          user = AdminUser.find_by(id: version.whodunnit)
          user ? auto_link(user) : version.whodunnit
        end
      end
      row :item do |version|
        if version.item_type && version.item_id
          begin
            item = version.item_type.constantize.find_by(id: version.item_id)
            if item
              link_to "#{version.item_type} ##{version.item_id}", send("edit_admin_#{version.item_type.underscore}_path", item)
            else
              "#{version.item_type} ##{version.item_id} (deleted)"
            end
          rescue
            "#{version.item_type} ##{version.item_id}"
          end
        end
      end
      row :event
      row :created_at do |version|
        version.created_at.strftime("%d.%m.%Y %H:%M")
      end
      row "User Agent", &:user_agent
      row "IP Address", &:ip if defined? version.ip
    end
  end

  filter :created_at

  controller do
    def scoped_collection
      super.reorder(created_at: :desc)
    end
  end
end
