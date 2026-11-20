ActiveAdmin.register Image do
  config.filters = true

  permit_params :title, :image

  menu priority: 10

  filter :title

  index as: :grid, columns: 4 do |image|
      link_to(image_tag(image.image.compact.url, width: 200), edit_admin_image_path(image)) +
      raw("<p><b>#{image.title}</p><p><a href='#' class='copy_to_clipboard'>Copy</a><input class='copy_to_clipboard_input' type='text' value='#{image.image.big.url}' /></b></p>")
  end

  form do |f|

    f.inputs "Image" do
      f.input :image, hint: f.object.image.url ? image_tag(f.object.image.compact.url) : nil
      f.input :title
    end

    f.submit "Save"

  end

  controller do
    def show
      redirect_to :admin_images
    end
  end

end