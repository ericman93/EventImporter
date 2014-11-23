class ChangeOutlookToLocalEvent < ActiveRecord::Migration
  def change
  	rename_table :outlook_importers, :local_importers
  end
end
