class CreateRedirects < ActiveRecord::Migration[7.0]
  def change
    create_table :redirects do |t|
      t.string :old_url
      t.string :new_url

      t.timestamps
    end
  end
end
