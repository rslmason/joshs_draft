class DraftsController < ApplicationController

  before_action :require_login

  before_action :nil_to_zero, only: [:create]
  


  def show
    @draft = Draft.find(params[:id])
    if @user
      get_selections
    end
  end

  def select 
    @draft = Draft.find(params[:id])
    if @draft.drawn? 
      @errors = ["The draft has already been drawn"]
      get_selections 
      render :show and return
    end
    # Rails.logger.info "params: #{params.inspect}"
    Rails.logger.info '----------'
    Rails.logger.info "selections: #{params[:selections]}"
    Rails.logger.info '----------'
    
    return unless @draft.users.include?(@user)
    params.permit! # revisit this
    selections = params[:selections]
    selections.each do |index_or_id, selection|
      Rails.logger.info "doing #{index_or_id} #{selection}"

      
      selection[:faction] = selection[:faction].to_i unless selection[:faction].nil? || selection[:faction] == ""
      if index_or_id.to_i >= 0 
        unless selection[:faction].present?
          Selection.find(index_or_id).destroy
          next
        end
        Selection.find(index_or_id).update(selection) # too bad that this permits an injection attack
      else
        next unless selection[:faction]
        selection.delete "id"
        Selection.create(selection.merge(draft_id: @draft.id, user_id: @user.id))
      end
    end
    @draft.touch
    redirect_to "/drafts/#{params[:id]}"

  end

  def index
    Rails.logger.info "This is a message from the controller"
    Rails.logger.info "the cookies are #{cookies[:user_token]}"
    @message = "This is a message from the controller"
    @drafts = @user.drafts
    # @open_drafts = Draft.where.not(id: @drafts.map(&:id))
    @open_drafts = Draft.left_joins(:users).group("drafts.id").having("count(users.id) < drafts.total_players")
    @open_drafts = @open_drafts.where.not(id: @drafts.map(&:id))
  end

  def new
    @draft = Draft.new
    @users = User.where.not(name: "<autoselect>")
    
  end

  def create
    @draft = Draft.new(draft_params)
    @draft.users = User.find(params[:user_ids]) if params[:user_ids].present?
    if @draft.save
      redirect_to drafts_path
    else
      Rails.logger.info "The draft did not save"
      Rails.logger.info @draft.errors.full_messages
      @errors = @draft.errors.full_messages
      @users = User.all
      render :new
    end
  end

  def join
    @draft = Draft.find(params[:id])
    @draft.users << @user unless @draft.users.include?(@user)
    if @draft.save
      redirect_to "/drafts/#{params[:id]}" and return
    else
      @errors = @draft.errors.full_messages
      get_selections
      render :show and return
    end
    
  end

  def delete
    return unless @user.admin
    @draft = Draft.find(params[:id]).destroy
    redirect_to :controller => 'main', :action => 'admin' and return
  end

  private

  def draft_params
    params.permit(:title, :description, :total_players, :num_selections, :draw)

  end

  def require_login
    if !@user
      redirect_to controller: 'main', action: 'login'
    end
  end

  def nil_to_zero

    Rails.logger.info "params: #{params.inspect}"

    params[:num_selections] = 0 if params[:num_selections].nil? || params[:num_selections] == ""
    params[:total_players] = 0 if params[:total_players].nil? || params[:total_players] == ""
    params[:draw] = 0 if params[:draw].nil? || params[:draw] == ""

    Rails.logger.info "params: #{params.inspect}"
  end

  def get_selections
    @selections = Selection.where(draft_id: @draft.id, user_id: @user.id)
    Rails.logger.info "There are #{@selections.count} selections"
    needed = @draft.num_selections - @selections.count
    Rails.logger.info "We need #{needed} more selections"
    if needed > 0
      Rails.logger.info "creating #{needed} more selections"
      @selections += needed.times.map { Selection.new(draft_id: @draft.id, user_id: @user.id) }
      Rails.logger.info "There are now #{@selections.length} selections"
    end 
    Rails.logger.info "Selections is #{@selections}"
  end

end