class ChangeExchangeImporteUserCoulomName < ActiveRecord::Migration
  def change
  	rename_column :exchange_importers, :user, :user_name
  end
end
