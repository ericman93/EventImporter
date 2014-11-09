class CreateRequest < ActiveRecord::Migration
  def change
    create_table :requests do |t|
    	t.string :return_mail
        t.string :return_name
     	t.string :location
     	t.string :subject
     	t.belongs_to :user

    	t.timestamps
    end
  end
end
