class AddServicesToUser < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.integer :time_in_minutes
      t.belongs_to :user

      t.timestamps
    end
  end
end
