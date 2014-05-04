json.array!(@events) do |event|
  json.extract! event, :id, :name, :location, :start_time, :end_time, :is_all_day, :organizer, :is_reccurnce
  json.url event_url(event, format: :json)
end
