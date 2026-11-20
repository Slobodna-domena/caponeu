ActiveAdmin.register News do
  menu priority: 6

  actions :all, :except => :show

  permit_params :title, :lead, :date, :venue, :contact, :topic, :priority, :gallery_title,
                galleries_attributes: [:_destroy, :id, :image, :video, :news_id, :caption]

  filter :title
  filter :date
  filter :topic

  index do
    column :title
    column :date
    column :topic
    column :priority do |news|
      case news.priority
      when 1
        "First"
      when 2
        "Second"
      when 3
        "Third"
      when 4
        "Not shown"
      end
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :lead, input_html: { class: "editor" }
      f.input :date
      f.input :venue
      f.input :contact
      f.input :topic
      f.input :priority, as: :select, collection: { "Don't show": 4, "First": 1, "Second": 2, "Third": 3 }
    end

    f.inputs "Gallery" do
      f.input :gallery_title
      f.has_many :galleries, allow_destroy: true do |g|
        g.input :image, hint: g.object.image.url ? image_tag(g.object.image.compact.url) : nil
        g.input :video, hint: "YouTube video ID"
        g.input :caption
      end
    end
    f.submit
  end
end
