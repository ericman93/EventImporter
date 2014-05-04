class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :location
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :is_all_day
      t.string :organizer
      t.boolean :is_reccurnce

      t.timestamps
    end
  end
end
