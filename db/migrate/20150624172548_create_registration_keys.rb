class CreateRegistrationKeys < ActiveRecord::Migration
  def change
    create_table :registration_keys do |t|
      t.string :key
      t.belongs_to :user

      t.timestamps
    end
  end
end
