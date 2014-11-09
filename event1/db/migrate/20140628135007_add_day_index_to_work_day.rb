class AddDayIndexToWorkDay < ActiveRecord::Migration
  def change
  	add_column :work_hours, :day_index, :integer
  end
end
