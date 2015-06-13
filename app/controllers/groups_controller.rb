class GroupsController < ApplicationController
	before_action :set_full_user, only: [:index, :show, :create, :add_user]
	before_action :get_group, only: [:show, :add_user]

	def index
		@groups = @current_full_user.groups
	end

	def show
		
	end

	def create
		@group = Group.new(group_params)
		respond_to do |format|
	    	if @group.save;
				@group.add(@current_full_user, as: 'manager')
	    		
	    		format.html { redirect_to @group, status: 302 }
	    		format.json { render action: 'show', status: :created, location: @group }
	    	else
	    	  	format.html { render action: 'edit' }
	    	  	format.json { render json: @user.errors, status: :unprocessable_entity }
	    	end
    	end
	end

	def add_group
		@group = Group.new
		render "edit"
	end

	def add_user
		user = User.where({user_name: params[:username]}).first
		if user.nil?
			@group.errors[:base] << "User '#{params[:username]}' could not be found"
			respond_to do |format|
				format.html { render action: 'show' }
	    	  	format.json { render json: @group.errors, status: :unprocessable_entity }
			end
		else
			@group.add user
			respond_to do |format|
				format.html { redirect_to  @group, status: 302 }
	    		format.json { render action: 'show', status: :created, location: @group }
			end	
		end
	end

	private
		def group_params
	      params.require(:group).permit(:name)
	    end

	    def get_group
	    	@group = Group.find(params[:id])
	    end
end