require 'digest/md5'

class UsersController < ApplicationController
  #protect_from_forgery with: :null_session
  # user before_filter for functions that need autorization

  def calendar
    @user_name = params[:username]
    render "calendar/calendar"
  end

  def new
    @user = User.new
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.work_hours = WorkHour.build_week

    respond_to do |format|
      if @user.save;
        format.html { redirect_to action: :login, controller: :permissions, status: 302 }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_work_days
    gmt_offset = params[:gmt].to_i
    user_name = params[:username]

    work_days = []
    user = User.where("user_name = ?",user_name).first
    if !user.nil?
      work_days = user.work_hours.order(:day_index)
    end

    render json: work_days.map{|d| {day: d.short_day_name, hours: [(d.start_at + (gmt_offset * 3600)), (d.end_at + (gmt_offset * 3600))]}} 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :user_name)
    end
end
