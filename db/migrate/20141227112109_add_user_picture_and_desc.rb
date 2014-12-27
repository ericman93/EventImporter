class AddUserPictureAndDesc < ActiveRecord::Migration
  def change
  	add_column :users, :desc, :text
  	add_column :users, :picture_path, :string
  end
end
