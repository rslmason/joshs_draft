class DraftsController < ApplicationController


  def show
    @draft = Draft.find(params[:id])
    if @user
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

  def select 
    Rails.logger.info "params: #{params.inspect}"
    @draft = Draft.find(params[:id])
    params.permit! # revisit this
    selections = params[:selections]
    selections.each do |index, selection|
      selection[:faction] = selection[:faction].to_i
      if index.to_i >= 0 
        Selection.find(index).update(selection) # too bad that this permits an injection attack
      else
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
    @open_drafts = Draft.joins(:users).group("drafts.id").having("count(users.id) < drafts.total_players")
    @open_drafts = @open_drafts.where.not(id: @drafts.map(&:id))
  end

  def new
    @draft = Draft.new
    @users = User.all
    
  end

  def create
    @draft = Draft.new(draft_params)
    @draft.users = User.find(params[:users]) if params[:users].present?
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
      @selections = Selection.where(draft_id: @draft.id, user_id: @user.id)
      render :show
    else
      @errors = @draft.errors.full_messages
      render :show
    end
  end


  private

  def draft_params
    params.permit(:title, :description, :total_players, :num_selections, :draw)

  end

end