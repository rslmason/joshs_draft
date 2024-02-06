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

  def admin
    redirect_to "/" and return unless @user
    unless User.where(admin: true).exists?
      @user.admin = true
      @user.save
    end
    unless @user.admin
      redirect_to "/"
    end
    @drafts = Draft.all
    @users = User.all
  end

end