class MainController < ApplicationController

  def index
    if params[:errors]
      if @errors 
        @errors += params[:errors]
      else
        @errors = params[:errors]
      end
    end
    @message = "welcome to my site"
    Rails.logger.info "The user_token is #{cookies[:user_token]}"
    # if cookies[:user_token]
    #   @user = User.find_by(token: cookies[:user_token])
    # end
    if @user
      @drafts = Draft.joins(:user).where(users: {name: @user.name})
    end
  end
end