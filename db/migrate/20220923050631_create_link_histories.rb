class CreateLinkHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :link_histories do |t|
      t.references :link, null: false, foreign_key: true
      t.string :ip
      t.string :browser
      t.string :platform

      t.timestamps
    end
  end
end
