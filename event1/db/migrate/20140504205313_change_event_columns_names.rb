class ChangeEventColumnsNames < ActiveRecord::Migration
  def change
  	rename_column :events, :name, :subject
  	rename_column :events, :organizer, :organizer_mail
  	add_column :events, :event_id, :text
  end
end
