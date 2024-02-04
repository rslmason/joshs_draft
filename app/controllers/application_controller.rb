class ApplicationController < ActionController::Base

  before_action :set_user

  def set_user
    if cookies[:user_token]
      @user = User.find_by(token: cookies[:user_token])
    end
  end
end
