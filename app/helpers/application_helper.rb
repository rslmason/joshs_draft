module ApplicationHelper

  def user_in_draft?
    return false unless @user && @draft
    UserDraft.where(user_id: @user.id, draft_id: @draft.id).exists?
  end

end
