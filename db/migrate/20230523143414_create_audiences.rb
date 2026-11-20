class CreateAudiences < ActiveRecord::Migration[7.0]
  def change
    create_table :audiences do |t|
      t.string :label

    end
  end
end
