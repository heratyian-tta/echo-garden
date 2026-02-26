class Users::SessionsController < Devise::SessionsController
  protected

  # Redirect after sign in
  def after_sign_in_path_for(resource)
    dashboard_index_path   # or whatever your dashboard index route helper is
  end
end
