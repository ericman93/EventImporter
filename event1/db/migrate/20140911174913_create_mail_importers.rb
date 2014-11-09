class CreateMailImporters < ActiveRecord::Migration
  def change
    create_table :mail_importers do |t|
		t.integer :importer_id
		t.string  :importer_type
		t.belongs_to :user

    	t.timestamps
    end
  end
end
