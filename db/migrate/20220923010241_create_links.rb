class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.string :title
      t.string :description
      t.string :url
      t.string :short_code
      t.string :alexa_rank

      t.timestamps
    end
  end
end
