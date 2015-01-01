class LocalEventsController < ApplicationController
	before_action :set_full_user, only: [:create, :add_event]

  	def create
		if (@current_full_user.mail_importer.any?{|importer| importer.specific.is_a? LocalImporter})
			format.html { redirect_to settings_path, notice: 'You already have an local importer' }
        	format.json { render :settings, status: :bad_request }
		end

	    importer = LocalImporter.new
	    importer.user = @current_full_user

	    respond_to do |format|
	     	if importer.save
	        	format.html { redirect_to settings_path, notice: 'Local importer was successfully created.' }
	        	format.json { render :settings, status: :ok }
	      	else
	        	format.html { render :web_mails }
	        	format.json { render json: importer.errors, status: :unprocessable_entity }
	      	end
    	end
 	end

 	def remove
 		importer = LocalImporter.find(params[:id])
 		importer.destroy
	    respond_to do |format|
	      format.html { redirect_to settings_path, notice: 'LocalImporter was successfully destroyed.' }
	      format.json { head :no_content }
	    end
 	end

 	def add_event
 		events = []
 		params[:events].each do |key, value|
 			event = Event.new
			event.start_time = DateTime.strptime(value['start_ticks'], '%Q')
			event.end_time = DateTime.strptime(value['end_ticks'], '%Q')
			event.subject = value['title']

			event_user = EventUser.new
			event_user.email = @current_full_user.email
			event.event_users << event_user

			events << event
 		end

		Event.transaction do
			events.each(&:save!)
		end

 		render json: true
 	end

 	private
 		def local_events_params
 			#.permit(:work_hours_attributes => [:id, :start_at, :end_at])
 			params.require(:events).permit(:events => [:end_ticks])
 		end
end