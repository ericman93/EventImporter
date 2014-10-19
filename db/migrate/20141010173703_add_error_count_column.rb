class AddErrorCountColumn < ActiveRecord::Migration
  def change
  	add_column :mail_importers, :error_count, :integer
  end
end
