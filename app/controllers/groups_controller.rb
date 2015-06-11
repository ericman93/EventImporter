class GroupsController < ApplicationController
	before_action :set_full_user, only: [:index]

	def index
		@groups = @current_full_user.groups
	end
end