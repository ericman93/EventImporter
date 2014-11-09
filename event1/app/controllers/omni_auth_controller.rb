class OmniAuthController < ApplicationController   
  before_action :has_user_session?  #, only: [:create]

  def create        
    auth = request.env["omniauth.auth"]
    exprire_at = auth["credentials"]["expires_at"]

    user = User.find(@current_user.id)
    if(user.mail_importer.all?{|importer| !(importer.specific.is_a? GmailImporter)})
      gmail_importer = GmailImporter.new
      gmail_importer.token = auth["credentials"]["token"]
      gmail_importer.refresh_token = auth["credentials"]["refresh_token"]
      gmail_importer.expiration_date = DateTime.strptime(exprire_at.to_s, '%s')

      user.mail_importer.push(gmail_importer)
      render json: user.save
    else
      g = user.mail_importer.select{|importer| importer.specific.is_a? GmailImporter}.first
      render json: g.specific.events(1410037200, 1410642000)
    end
  end
end