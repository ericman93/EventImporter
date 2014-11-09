class AddIsApprovedToEventUsers < ActiveRecord::Migration
  def change
  	add_column :event_users, :is_approved, :boolean
  end
end
