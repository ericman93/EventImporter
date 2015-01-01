class OmniAuthController < ApplicationController   
  before_action :has_user_session?  #, only: [:create]
  before_action :set_full_user, only: [:create]

  def create        
    auth = request.env["omniauth.auth"]
    exprire_at = auth["credentials"]["expires_at"]

    if(@current_full_user.mail_importer.all?{|importer| !(importer.specific.is_a? GmailImporter)})
      gmail_importer = GmailImporter.new
      gmail_importer.token = auth["credentials"]["token"]
      gmail_importer.refresh_token = auth["credentials"]["refresh_token"]
      gmail_importer.expiration_date = DateTime.strptime(exprire_at.to_s, '%s')

      @current_full_user.mail_importer.push(gmail_importer)
      render json: @current_full_user.save
    else
      render json: true
    #  g = user.mail_importer.select{|importer| importer.specific.is_a? GmailImporter}.first
    #  render json: g.specific.events(1410037200, 1410642000)
    end
  end
end