class Msu1PackMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :msu1_pack_mappings do |t|
      t.string     :track_number,     null: false
      t.belongs_to :msu1_pack,        null: false
      t.belongs_to :msu1_pcm_track,   null: false
      t.belongs_to :msu1_patch_track, null: false

      t.timestamps
    end
  end
end
