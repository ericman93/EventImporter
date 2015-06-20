class ChangeWorkHourIntergers < ActiveRecord::Migration
  def change
  	change_column :work_hours, :start_at, :time
  	change_column :work_hours, :end_at, :time
  end
end
