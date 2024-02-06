class UsersController < ApplicationController

  def new
    
  end

  def create
    @user = User.new(user_params)
    if @user.save
      cookies.permanent[:user_token] = @user.token
      redirect_to :controller => 'main', :action => 'index'
    else
      @errors = @user.errors.full_messages
      render :new
    end
  end

  def login
    @user = User.find_by(name: params[:name])
    # there is no authenticate!
    if @user && @user.password == (params[:password])
      cookies.permanent[:user_token] = @user.token
      # todo: redirect to the page the user was trying to access
      redirect_to :controller => 'main', :action => 'index'
      # redirect_back(fallback_location: root_path)
    else
      redirect_back fallback_location: root_path
    end
  end

  def logout
    Rails.logger.info "The logout action received params: #{params.inspect}"
    cookies.delete(:user_token)
    redirect_back(fallback_location: root_path)
  end

  def delete
    return unless @user.admin
    @user = User.find(params[:id]).destroy
    redirect_to :controller => 'main', :action => 'admin' and return
  end

  private 

  def user_params
    params.permit(:name, :password)
  end
end