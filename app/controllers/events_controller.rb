class EventsController < ApplicationController
  before_action :has_user_session?, only: [:user_requests_events]

  def user_events
    user_name = params[:username]
    start_time = params[:start].to_i
    end_time = params[:end].to_i

    user = User.where({user_name: user_name}).first

    other_user = (@current_user.nil? or @current_user.user_name != user_name)
    events = user.events(start_time, end_time).sort{|x,y| x.start_time <=> y.start_time}
    
    if other_user
      events = CalendarApiHelper.combine_events(events, logger)
    end

    render json: events.map{|e| e.to_fullcalendar_json(other_user) }
    #render json: user.mail_importer.first.specific.events(start_time, end_time)
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
