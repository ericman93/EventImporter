class AboutController < ApplicationController
  def about
  	eric = StaffMember.new()
  	eric.name = "Eric Feldman"
  	eric.desc = "CTO"
  	eric.tags = ["Ruby", ".Net", "Rails"]
  	eric.pic_name = "eric.jpg"
  	eric.location = "Israel"

  	gadi = StaffMember.new()
  	gadi.name = "Gadi Feldman"
  	gadi.desc = "CEO"
  	gadi.tags = ["Citrix", "Father", "Virtualizton"]
  	gadi.pic_name = "gadi.jpg"
  	gadi.location = "Israel"

  	@staff = [eric, gadi]
  end
end