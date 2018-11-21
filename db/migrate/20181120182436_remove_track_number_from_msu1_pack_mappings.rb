class RemoveTrackNumberFromMsu1PackMappings < ActiveRecord::Migration[5.2]
  def change
    remove_column(:msu1_pack_mappings, :track_number)
  end
end
