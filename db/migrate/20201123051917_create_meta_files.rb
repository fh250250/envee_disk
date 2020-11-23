class CreateMetaFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :meta_files do |t|
      t.string     :name,   null: false
      t.references :folder, null: false, foreign_key: true
      t.references :blob,   null: false, foreign_key: true
      t.timestamps

      t.index [:folder_id, :name], unique: true
    end
  end
end
