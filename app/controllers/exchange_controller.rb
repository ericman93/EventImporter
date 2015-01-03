class ExchangeController < ApplicationController
	before_action :set_full_user, only: [:create]

  	def create
		if (@current_full_user.mail_importer.any?{|importer| importer.specific.is_a? ExchangeImporter})
			format.html { redirect_to settings_mails_path, notice: 'You already have an excahnge importer' }
        	format.json { render :settings, status: :bad_request }
		end

	    importer = ExchangeImporter.new(importer_params)
	    importer.user = @current_full_user

	    respond_to do |format|
	     	if importer.save
	        	format.html { redirect_to settings_mails_path, notice: 'Exchange importer was successfully created.' }
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
				format.html { redirect_to settings_mails_path, notice: 'Exchange importer was successfully updatetd' }
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
	      format.html { redirect_to settings_mails_path, notice: 'ExchangeImporter was successfully destroyed.' }
	      format.json { head :no_content }
	    end
 	end

 	def test
 		info = params[:echange_info]

 		result = ExchangeHelper.test_connection(info['server'], info['user_name'], info['password'])

 		render json: result, status: (result ? 200 : 400)
 	end

 	def reset_errors
 		importer = ExchangeImporter.find(params[:id])
 		importer.error_count = 0;
 		
 		respond_to do |format|
			if importer.save
	      		format.html { redirect_to settings_mails_path, notice: 'Successfully reset errors.' }	
	      		format.json { head :no_content }
	      	else
	      		format.html { render :web_mails }
	        	format.json { render json: importer.errors, status: :unprocessable_entity }
	      	end
	    end
 	end

	def importer_params
      params.require(:exchange_importer).permit(:user_name, :password, :server)
    end
end