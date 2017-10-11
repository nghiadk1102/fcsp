class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:show, :edit]
  before_action :authenticate_tms

  def show
    @user_object = Supports::ShowUser.new @user, current_user, params
    @courses = @user.courses.includes :programming_language

    if request.xhr?
      if params[:suggest_jobs_page]
        return render json: {
          content: render_to_string(partial: "job_accordance", locals:
            {jobs: @user_object.user_jobs, job_page: :suggest_jobs_page})
        }
      end

      if params[:bookmarked_jobs_page]
        return render json: {
          content: render_to_string(partial: "job_accordance",
            locals: {jobs: @user_object.bookmarked_jobs,
            job_page: :bookmarked_jobs_page})
        }
      end
    end
    respond_to do |format|
      format.html
      format.json {
        render json: {
          status: :success,
          html: render_to_string(partial: "users/course_users", formats: :html,
          locals: {user: @user, courses: @courses, subjects: @subjects}, layout: false)
        }
      }
      format.js
    end
  end

  def new
  end

  def update
    if current_user.update_attributes auto_synchronize: params[:auto_synchronize]
      flash[:success] = t ".auto_synchronize_success"
    else
      flash[:error] = t ".auto_synchronize_error"
    end
    redirect_to current_user
  end

  private

  def find_user
    @user = User.includes(:info_user).find_by id: params[:id]

    return if @user
    flash[:danger] = t ".not_found"
    redirect_to root_url
  end
end
