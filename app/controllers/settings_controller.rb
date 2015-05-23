require 'net/http'

class SettingsController < ApplicationController
	before_action :has_user_session?
	#before_action :set_user, only: [:save_work_hours,:save_services, :work_hours, :web_mails, :logout_gmail, :services, :user_settings]
  before_action :set_full_user, except: [:settings]

	def settings
	end

	def services
	end

 	def work_hours
	end

	def web_mails
	end

	def save_work_hours
    gmt_offset = params[:gmt].to_i

  	respond_to do |format|
     	if @current_full_user.update(work_hours_params(gmt_offset))
        	format.html { redirect_to :settings_hours, notice: 'Your work hours was successfully updated.' }
        	format.json { render :work_hours, status: :ok }
      	else
        	format.html { render :work_hours }
        	format.json { render json: @current_full_user.errors, status: :unprocessable_entity }
      	end
  	end
	end

	def save_services
		result = true

		Service.transaction do
			result &= @current_full_user.services.destroy_all
			result &= @current_full_user.update(services_params)

			raise ActiveRecord::Rollback unless result
		end

		respond_to do |format|
     	if result
        	format.html { redirect_to :settings_services, notice: 'Your services was successfully updated.' }
        	format.json { render :services, status: :ok }
      	else
        	format.html { render :services }
        	format.json { render json: @current_full_user.errors, status: :unprocessable_entity }
      	end
    	end
	end

	def logout_gmail    
		gmail = @current_full_user.mail_importer.select{|importer| importer.specific.is_a? GmailImporter}.first
		if(gmail.nil?)
			render :nothing => true, :status => 400
		end

    revoked = revoke_google_token(gmail)
    if(revoked)
      gmail.destroy
    end 

		respond_to do |format|
      if revoked
        format.html { redirect_to :settings_mails , notice: 'You have been successfully logout from gmail.' }
        format.json { head :ok }
      else
        format.html { redirect_to :settings_mails , notice: 'Error while logout, Please try again' }
        format.json { render :nothing => true, :status => 400 }
      end
    end
	end

  def user_settings
  end

  def upload_pictute
    user = params[:user].permit(:desc, :is_auto_approval)
    uploaded_io = user[:picture]
    if(!uploaded_io.nil?)
      picture_path = Rails.root.join('public', 'user_photos', "#{@current_full_user.user_name}.jpg") #uploaded_io.original_filename
      File.open(picture_path, 'wb') do |file|
        file.write(uploaded_io.read)
      end

      @current_full_user.picture_path = picture_path.to_s
    end

    render json: uploaded_io
    #respond_to do |format|
    #  #if(@current_full_user.save)
    #  if(@current_full_user.update(user))
    #    format.html { redirect_to :settings_user, notice: 'Your picture was successfully updated.' }
    #    format.json { render :services, status: :ok }
    #  else
    #    format.html { render :user_settings }
    #    format.json { render json: @current_full_user.errors, status: :unprocessable_entity }
    #  end
    #end
  end

	private
    def revoke_google_token(gmail)
      url = URI.parse("https://accounts.google.com/o/oauth2/revoke?token=#{gmail.get_token}")
      req = Net::HTTP::Get.new(url.to_s)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      res = http.request(req)

      res.kind_of? Net::HTTPSuccess
    end

    def work_hours_params(gmt)
    		work_hours = params.require(:user).permit(:work_hours_attributes => [:id, :start_at, :end_at])

    		# from HH:mm to seconds after midnight in UTC
    		work_hours[:work_hours_attributes].each do |id, work_hour|
			  work_hour['start_at'] = get_seconds_from_display(work_hour['start_at'], gmt)
			  work_hour['end_at'] = get_seconds_from_display(work_hour['end_at'], gmt)
    		end

    		return work_hours
  	end

  	def services_params
    		params.require(:user).permit(:services_attributes => [:name, :time_in_minutes])
  	end

  	def get_seconds_from_display(display, gmt)
  		if display.nil?
  			# vication
  			return -(gmt*3600)
  		else
  			splited = display.split(':')
  			return (splited[0].to_i*3600) + (splited[1].to_i*60) - (gmt*3600)
  		end
  	end
end