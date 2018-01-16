class Setting::ProfilesController < Setting::BaseController
  def index
    @users = User.other_user current_user.id
    @limit_users = current_user.user_shares.includes(:avatar).recommend
  end
end
