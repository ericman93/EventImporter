class ExchangeController < ApplicationController
  	def create
  		user = User.find(@current_user.id)
		if (user.mail_importer.any?{|importer| importer.specific.is_a? ExchangeImporter})
			format.html { redirect_to settings_path, notice: 'You already have an excahnge importer' }
        	format.json { render :settings, status: :bad_request }
		end

	    importer = ExchangeImporter.new(importer_params)
	    importer.user = @current_user

	    respond_to do |format|
	     	if importer.save
	        	format.html { redirect_to settings_path, notice: 'Exchange importer was successfully created.' }
	        	format.json { render :settings, status: :ok }
	      	else
	        	format.html { render :web_mails }
	        	format.json { render json: importer.errors, status: :unprocessable_entity }
	      	end
    	end
 	end

 	def edit
 		importer = ExchangeImporter.find(params[:exchange_importer][:id])
 		respond_to do |format|
	 		if importer.update(importer_params)
				format.html { redirect_to settings_path, notice: 'Exchange importer was successfully updatetd' }
		        format.json { render :settings, status: :ok }
		    else
		      	format.html { render :web_mails }
		      	format.json { render json: importer.errors, status: :unprocessable_entity }
		    end
		end
 	end

 	def remove
 		importer = ExchangeImporter.find(params[:id])
 		importer.destroy
	    respond_to do |format|
	      format.html { redirect_to settings_path, notice: 'ExchangeImporter was successfully destroyed.' }
	      format.json { head :no_content }
	    end
 	end

	def importer_params
      params.require(:exchange_importer).permit(:user_name, :password, :server)
    end
end