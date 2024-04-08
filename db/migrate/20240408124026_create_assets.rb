class CreateAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :assets do |t|
      t.references :page, null: false, foreign_key: true
      t.string :url

      t.timestamps
    end
  end
end
