class AddRefreshTokenAndExpresionDate < ActiveRecord::Migration
  def change
  	add_column :gmail_importers, :refresh_token, :string
  	add_column :gmail_importers, :expiration_date, :datetime
  end
end
