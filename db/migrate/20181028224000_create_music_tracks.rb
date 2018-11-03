class CreateMusicTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :music_tracks do |t|
      t.string     :type,      null: false
      t.string     :filename,  null: false
      t.belongs_to :videogame, null: false

      t.timestamps
    end
  end
end
