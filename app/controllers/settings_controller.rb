class SettingsController < ApplicationController
	before_action :has_user_session?
	@@days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

	def settings
	end

 	def work_hours
 		@user_work_hours = User.find(@current_user.id).work_hours.order(:day_index)
	    #@days = [{short_name: 'sun' , full_name: 'Sunday'},
	    #         {short_name: 'mon' , full_name: 'Monday'},
	    #         {short_name: 'tue' , full_name: 'Tuesday'},
	    #         {short_name: 'wed' , full_name: 'Wednesday'},
	    #         {short_name: 'thu' , full_name: 'Thursday'},
	    #         {short_name: 'fri' , full_name: 'Friday'},
	    #         {short_name: 'sat' , full_name: 'Saturday'}]

         render partial: 'work_hours'
	end

	def web_mails
		render partial: 'web_mails'
	end

  	def save_work_hours
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
	    def work_hours_params(gmt_offset)
      		params.require(:work_days).map{|day| day[1]}.each{|d| 
		        d['start_at'] = d['start_at'].to_i - (gmt_offset * 3600)
		        d['end_at'] = d['end_at'].to_i - (gmt_offset * 3600)
	      	}
    	end
end