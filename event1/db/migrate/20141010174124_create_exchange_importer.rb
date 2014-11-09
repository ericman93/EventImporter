class CreateExchangeImporter < ActiveRecord::Migration
  def change
    create_table :exchange_importers do |t|
    	t.string :token
    	t.string :user
		t.string  :password
		t.string  :server

    	t.timestamps
    end
  end
end
