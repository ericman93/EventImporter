class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def user_events
    email = params[:email]
    start_time = params[:start]
    end_time = params[:end]

    # use the timstamps for better selection
    user = User.where("email = ?",email).first

    request_self_events = !(@current_user.nil?) and @current_user.email == email;
    events = user.events.sort{|x,y| x.start_time <=> y.start_time}
    
    if !request_self_events
      events = CalendarApiHelper.combine_events(events, logger)
    end

    render json: events.map{|e| e.to_fullcalendar_json(!request_self_events) }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :location, :start_time, :end_time, :is_all_day, :organizer, :is_reccurnce)
    end
end
