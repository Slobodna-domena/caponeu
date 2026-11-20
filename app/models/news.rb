class News < ApplicationRecord

  has_many :galleries, -> { order(:id) }

  accepts_nested_attributes_for :galleries, allow_destroy: true

  extend FriendlyId
  friendly_id :title, :use => [:slugged, :finders]

  before_create do
    News.where("priority >= ? AND priority < 4", self.priority)
        .map {|news| news.update_column :priority, news.priority + 1} if self.priority != 4
  end

  before_update do
      if self.priority < 4 then
        t = News.where(priority: self.priority).take 1
       if !t.empty? then
          old_priority = News.find(self.id).priority
          t[0].update_column :priority, old_priority
       end
      end
  end

  scope :ordered_for_news_page, -> {
    order(
      Arel.sql("CASE WHEN priority BETWEEN 1 AND 3 THEN 0 ELSE 1 END"),
      Arel.sql("CASE WHEN priority BETWEEN 1 AND 3 THEN priority ELSE NULL END"),
      id: :desc
    )
  }

  def self.ransackable_attributes(auth_object = nil)
    ["contact", "created_at", "date", "id", "is_published", "lead", "title", "topic", "updated_at", "venue", "slug", "gallery_title"]
  end

end
