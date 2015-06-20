class AboutController < ApplicationController
  def about
  	eric = StaffMember.new()
  	eric.name = "Eric Feldman"
  	eric.desc = "CTO"
  	eric.tags = ["Code Monkey"]
  	eric.pic_name = "eric.jpg"
  	eric.location = "Israel"

  	gadi = StaffMember.new()
  	gadi.name = "Gadi Feldman"
  	gadi.desc = "CEO"
  	gadi.tags = ["Chief of Design"]
  	gadi.pic_name = "gadi.jpg"
  	gadi.location = "Israel"

  	@staff = [eric, gadi]
  end

  def home
    #@show_login = params[:show_login]
    #params[:show_login] = nil
  end
end