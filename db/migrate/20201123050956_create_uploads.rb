class CreateUploads < ActiveRecord::Migration[6.0]
  def change
    create_table :uploads do |t|
      t.string     :name,         null: false
      t.string     :sha256,       null: false, limit: 64
      t.string     :content_type, null: false
      t.bigint     :size,         null: false
      t.integer    :part_size,    null: false
      t.integer    :cursor,       null: false, default: 0
      t.references :folder,       null: false, foreign_key: true
      t.timestamps

      t.index [:folder_id, :sha256], unique: true
    end
  end
end