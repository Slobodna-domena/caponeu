module ActiveAdmin

  module SharedModule
    def self.extended(base)
      base.instance_eval do
        class_ = base.config.resource_class
        return unless class_
        selectize_new_autocreate
      end
    end

    def selectize_new_autocreate

      before_action :create_has_many_models, only: [:create, :update]
      controller do

        def create_has_many_models
          @class_ = self.resources_configuration[:self][:instance_name].to_s.classify.constantize
          reflections = (@class_.reflect_on_all_associations(:has_and_belongs_to_many) + @class_.reflect_on_all_associations(:has_many))
          reflections.each do |item|
            create_selectize_relationship(item.klass)
          end
        end

        def create_selectize_relationship(relationship)
          return if relationship.nil?
          relationship_symbol = relationship.to_s.downcase.to_sym
          class_sym = @class_.name.downcase.to_sym
          return if params[class_sym]["#{relationship_symbol}_ids"].blank?
          params[class_sym]["#{relationship_symbol}_ids"].each do |name|
            next if name.blank?
            if relationship.find_by(id: name).nil?
              new_obj = relationship.new(label: name)
              new_obj.save!
              params[class_sym]["#{relationship_symbol}_ids"][params[class_sym]["#{relationship_symbol}_ids"].index(name)] = "#{new_obj.id}"
            end
          end
        end
        
      end
    end

 end
end