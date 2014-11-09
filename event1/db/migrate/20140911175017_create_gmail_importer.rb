class CreateGmailImporter < ActiveRecord::Migration
  def change
    create_table :gmail_importers do |t|
    	t.string :token
    	
    	t.timestamps
    end
  end
end
