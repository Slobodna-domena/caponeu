class CreateNews < ActiveRecord::Migration[7.0]
  def change
    create_table :news do |t|
      t.string :title
      t.text :lead
      t.string :date
      t.string :venue
      t.string :contact
      t.string :topic
      t.boolean :is_published

      t.timestamps
    end
  end
end
