require 'digest/md5'

class UsersController < ApplicationController
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
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

    #if authenticate?(email, plaintext_password)
    if(!User.authenticate_by_mail(email, plaintext_password))
        redirect_to action: :login, status: 302
    else
        session[:current_user] = User.find_by email: email
        redirect_to action: :calendar, status: 302, email: email
    end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :email)
    end

    def authenticate?(email, plain_password)
      if(!User.authenticate_by_mail(email, plain_password))
        redirect_to action: :login, status: 302
      end
  end
end
