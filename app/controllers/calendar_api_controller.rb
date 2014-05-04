class CalendarApiController < ApplicationController
	protect_from_forgery with: :null_session

	def insert
		user_id = params[:userId]
		hashed_password = params[:hashedPassword]
		events = Event.from_json params[:events] 

		render json: events.map{|e| e.subject}
	end
end