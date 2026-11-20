ActiveAdmin::Devise::SessionsController.class_eval do

  def after_sign_in_path_for(resource_or_scope)
    root_url
  end
  
  def after_sign_out_path_for(resource_or_scope)
    root_url
  end
  
  def sign_out_and_redirect(resource_or_scope)
    root_url
  end
  
  def signed_in_root_path(resource_or_scope)
    root_url
  end

end

ActiveAdmin::Devise::RegistrationsController.class_eval do
  
  def after_update_path_for(resource_or_scope)
    root_url
  end

end