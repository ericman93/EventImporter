class UserMailer < ActionMailer::Base
	def import_fail(user_mail, importer_name)
	  	mail(to: user_mail, subject: "Your #{importer_name} has reach maximum errors")
	end	
end