class CreateMsu1PatchTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :msu1_patch_tracks do |t|
      t.integer    :track_number,  null: false
      t.string     :friendly_name, null: false
      t.belongs_to :msu1_patch,    null: false

      t.timestamps
    end
  end
end
