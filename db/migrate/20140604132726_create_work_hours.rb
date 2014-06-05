class CreateWorkHours < ActiveRecord::Migration
  def change
    create_table :work_hours do |t|
      t.string :day
      t.integer :start_at
      t.integer :end_at
      t.belongs_to :user

      t.timestamps
    end
  end
end
