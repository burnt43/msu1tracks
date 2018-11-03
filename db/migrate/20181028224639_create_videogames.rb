class CreateVideogames < ActiveRecord::Migration[5.2]
  def change
    create_table :videogames do |t|
      t.string     :name,          null: false
      t.string     :friendly_name, null: false
      t.belongs_to :console,       null: false

      t.timestamps
    end
  end
end
