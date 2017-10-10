class TmsSynchronizeController < ApplicationController
  before_action :authenticate_tms
  def index
    tms_synchronize = Api::TmsDataService.new current_user, @user_token
    if tms_synchronize.synchronize_tms_data
      flash[:success] = t ".synchronize_success"
    else
      flash[:error] = t ".synchronize_fail"
    end
    redirect_to current_user
  end

  def auto_synchronize
    if current_user.update_attributes auto_synchronize: params[:auto_synchronize]
      flash[:success] = t ".auto_synchronize_success"
    else
      flash[:error] = t ".auto_synchronize_error"
    end
    redirect_to current_user
  end
end
