class CreateMsu1PatchesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :msu1_patches do |t|
      t.string     :name,          null: false
      t.string     :friendly_name, null: false
      t.belongs_to :videogame,     null: false

      t.timestamps
    end
  end
end
