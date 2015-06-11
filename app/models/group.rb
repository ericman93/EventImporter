class Group < ActiveRecord::Base  
  groupify :group, members: [:users, :assignments], default_members: :users

  def to_sym
  	name.to_sym
  end
end