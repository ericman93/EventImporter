require 'digest/md5'

class UsersController < ApplicationController
  #protect_from_forgery with: :null_session
  # user before_filter for functions that need autorization

  def calendar   
    @calendar_user = Group.where({name: params[:username]}).first
    if(@calendar_user.nil?)
      @calendar_user = User.where({user_name: params[:username]}).first
    end 
    
    @is_local_events = false
    if params[:username] == @current_username
      @is_local_events = @calendar_user.mail_importer.any?{|importer| (importer.specific.is_a? LocalImporter)}
    end

    render "calendar/calendar"
  end

  def new
    @user = User.new
  end

  def create
    request_params = user_params
    key = RegistrationKey.where(:key => request_params['registration_key']['key']).first
    request_params[:registration_key] = nil

    @user = User.new(request_params)
    if(key.nil? or !key.user.nil?)
      @user.errors[:base] << "Bad key"
    else 
      @user.work_hours = WorkHour.build_week
      @user.registration_key = key
    end

    @user.password = Digest::MD5.hexdigest(@user.password)

    respond_to do |format|
      if @user.errors[:base].empty? and @user.save;
        format.html { redirect_to :root, status: 302 }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_work_days
    #gmt_offset = params[:gmt].to_i
    gmt_offset = 0
    user_name = params[:username]

    work_days = []
    user = User.where("user_name = ?",user_name).first
    if !user.nil?
      work_days = user.work_hours.order(:day_index)
    end

    #render json: work_days.map{|d| {day: d.short_day_name, hours: [(d.start_at + (gmt_offset * 3600)), (d.end_at + (gmt_offset * 3600))]}} 
    render json: work_days.each_with_object({}) { |value,hash| hash[value.short_day_name] = {
        "start" => value.start_at + (gmt_offset * 3600),
        "end" => value.end_at + (gmt_offset * 3600)
      }
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :user_name, registration_key: [:key])
    end
end
