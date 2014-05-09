class CreateRequestProposals < ActiveRecord::Migration
  def change
    create_table :request_proposals do |t|
    	t.datetime :start_time
      	t.datetime :end_time
     	t.belongs_to :request

    	t.timestamps
    end
  end
end
