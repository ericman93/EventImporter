class MailImporter < ActiveRecord::Base
	acts_as_superclass :as => :importer
	belongs_to :user

	def events(start_time, end_time)
	end

	def make_call_to_server(possible_errors, default_result)
		if (!self.error_count.nil?) && (self.error_count > possible_errors)
			return default_result
		end

		if block_given?
			begin
	    		return yield
    		rescue
    			self.error_count = self.error_count || 0
    			self.error_count += 1
    			self.save

    			if(self.error_count == possible_errors)
    				handle_max_error();
    			end

    			return default_result
    		end
	  	end
	end

	def handle_max_error
		# Send mail
	end
end
