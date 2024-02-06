class MainController < ApplicationController

  def index
    if params[:errors]
      if @errors 
        @errors += params[:errors]
      else
        @errors = params[:errors]
      end
    end
    
    if @user
      @drafts = Draft.joins(:user).where(users: {name: @user.name})
    end
  end
end