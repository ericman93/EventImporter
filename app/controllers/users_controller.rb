require 'digest/md5'

class UsersController < ApplicationController
  before_action :has_user_session?, only: [:requests, :requests_partial, :settings]
  #protect_from_forgery with: :null_session
  # user before_filter for functions that need autorization

  def login
    if !@current_user.nil?
       redirect_to @current_user
    else
      render :login
    end
  end

  def logout
    session[:current_user] = nil
    redirect_to action: :login, status: 302
  end

  def authenticate
    plaintext_password = params[:password]
    email = params[:email]

    if(!User.authenticate_by_mail(email, plaintext_password))
        redirect_to action: :login, status: 302
    else
        session[:current_user] = User.find_by email: email
        redirect_to action: :calendar, status: 302, email: email
    end
  end

  def get_work_days
    gmt_offset = params[:gmt].to_i
    email = params[:email]

    work_days = []
    user = User.where("email = ?",email).first
    if !user.nil?
      work_days = user.work_hours.order(day_index: :desc)
    end

    render json: work_days.map{|d| {day: d.short_day_name, hours: [(d.start_at + (gmt_offset * 3600)), (d.end_at + (gmt_offset * 3600))]}} 
  end

  def requests_count
    requests_count = 0
    if !session[:current_user].nil?
      requests_count = User.find(session[:current_user].id).requests.size
    end

    render json: requests_count
  end

  def requests
  end

  def requests_partial
    @requests = User.find(@current_user.id).requests
    render partial: 'requests'
  end

  def calendar
    @user = params[:email]
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

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def settings
    @days = [{short_name: 'sun' , full_name: 'Sunday'},
             {short_name: 'mon' , full_name: 'Monday'},
             {short_name: 'tue' , full_name: 'Tuesday'},
             {short_name: 'wed' , full_name: 'Wednesday'},
             {short_name: 'thu' , full_name: 'Thursday'},
             {short_name: 'fri' , full_name: 'Friday'},
             {short_name: 'sat' , full_name: 'Saturday'}]
  end

  def save_work_days
    gmt_offset = params[:gmt].to_i

    user = User.find(@current_user.id)
    if(user.work_hours.empty?)
      user.work_hours.build(work_hours_params(gmt_offset))
      user.save
    else
      user.update_work_days(work_hours_params(gmt_offset))    
    end

    render json: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:day, :start_at, :end_at, :short_day_name)
    end

    def work_hours_params(gmt_offset)
      params.require(:work_days).map{|day| day[1]}.each{|d| 
        d['start_at'] = d['start_at'].to_i - (gmt_offset * 3600)
        d['end_at'] = d['end_at'].to_i - (gmt_offset * 3600)
      }
    end

    def authenticate?#(email, plain_password)
      if(!User.authenticate_by_mail(email, plain_password))
        redirect_to action: :login, status: 302
      end
    end

    def has_user_session?
      if session[:current_user].nil?
        redirect_to action: :login, status: 302
      end
    end

end
