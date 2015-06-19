class EventsController < ApplicationController
  before_action :set_current_username, only: [:user_events]

  def user_events
    user_name = params[:username]
    start_time = DateTime.iso8601 params[:start]
    end_time = DateTime.iso8601 params[:end]

    is_other_user = @current_username != user_name

    user = Group.where({name: user_name}).first
    if(user.nil?)
      user = User.where({user_name: user_name}).first
    end

    events = user.events(start_time, end_time).sort{|x,y| x.start_time <=> y.start_time}
    
    if is_other_user
      events = CalendarApiHelper.combine_events(events, logger)
    end

    render json: events.map{|e| e.to_fullcalendar_json(is_other_user) }
  end

  def show
    @event = Event.find(params[:id])
  end

  #def user_requests_events
  #  start_time = params[:start]
  #  end_time = params[:end]
  #  request_id = params[:request_id]
  #  request = Request.find(request_id)
  #  proposals = request.request_proposals.map{|p| p.to_fullcalendar_json(request.location)}
  #  user_events = request.user.events.map{|e| e.to_fullcalendar_json(false)}
  #  render json: proposals + user_events
  #end
end
