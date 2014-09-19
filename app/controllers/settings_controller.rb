class SettingsController < ApplicationController
	before_action :has_user_session?
	before_action :set_user, only: [:save_work_hours, :work_hours, :web_mails]

	def settings
	end

 	def work_hours
		render partial: 'work_hours'
	end

	def web_mails
		render partial: 'web_mails'
	end

  	def save_work_hours
	    gmt_offset = params[:gmt].to_i

    	respond_to do |format|
	     	if @user.update(work_hours_params(gmt_offset))
	        	format.html { redirect_to settings_path, notice: 'Your work hours was successfully updated.' }
	        	format.json { render :settings, status: :ok }
	      	else
	        	format.html { render :work_hours }
	        	format.json { render json: @user.errors, status: :unprocessable_entity }
	      	end
    	end
  	end

  	private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_user
	      @user = User.find(@current_user.id)
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