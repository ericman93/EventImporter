class EventsController < ApplicationController
  before_action :has_user_session?, only: [:user_requests_events]

  def user_events
    email = params[:email]
    start_time = params[:start]
    end_time = params[:end]

    # use the timstamps for better selection !!!!
    user = User.where("email = ?",email).first

    other_user = (@current_user.nil? or @current_user.email != email)
    events = user.events.sort{|x,y| x.start_time <=> y.start_time}
    
    if other_user
      events = CalendarApiHelper.combine_events(events, logger)
    end

    render json: events.map{|e| e.to_fullcalendar_json(other_user) }
  end

  def user_requests_events
    start_time = params[:start]
    end_time = params[:end]
    request_id = params[:request_id]

    request = Request.find(request_id)
    proposals = request.request_proposals.map{|p| p.to_fullcalendar_json(request.location)}
    user_events = request.user.events.map{|e| e.to_fullcalendar_json(false)}

    render json: proposals + user_events
  end

  private
    def has_user_session?
      if session[:current_user].nil?
        redirect_to action: :login, controller: :users, status: 302
      end
    end
end
