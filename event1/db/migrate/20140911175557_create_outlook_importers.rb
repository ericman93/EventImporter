class CreateOutlookImporters < ActiveRecord::Migration
  def change
    create_table :outlook_importers do |t|
    	t.timestamps
    end
  end
end
