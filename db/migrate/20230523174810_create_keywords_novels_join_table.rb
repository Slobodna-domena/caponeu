class CreateKeywordsNovelsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :keywords, :novels
  end
end
