class CreateBlobs < ActiveRecord::Migration[6.0]
  def change
    create_table :blobs do |t|
      t.string :sha256,       null: false, limit: 64
      t.string :content_type, null: false
      t.bigint :size,         null: false
      t.timestamps

      t.index :sha256, unique: true
    end
  end
end
