module DateHelper
	include ActionView::Helpers::TagHelper

	def self.format_date(time, format)
		time = time.to_time
  		ActionController::Base.helpers.content_tag(:span, I18n.l(time, format: :long), data: { format: format, time: time.to_i })	
	end
end