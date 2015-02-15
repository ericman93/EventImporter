class AddIsAutoAprrovelToUser < ActiveRecord::Migration
  def change
	add_column :users, :is_auto_approval, :boolean
  end
end
