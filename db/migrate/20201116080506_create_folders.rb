class CreateFolders < ActiveRecord::Migration[6.0]
  def change
    create_table :folders do |t|
      t.string     :name,           null: false
      t.references :user,           null: false, foreign_key: true
      t.references :parent,         foreign_key: { to_table: :folders }
      t.integer    :lft,            null: false, index: true
      t.integer    :rgt,            null: false, index: true
      t.integer    :depth,          null: false, default: 0, index: true
      t.integer    :children_count, null: false, default: 0
      t.timestamps

      t.index [:parent_id, :name], unique: true
    end
  end
end
