class CreateAdaptationTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :adaptation_types do |t|
      t.string :label

      t.timestamps
    end
  end
end
