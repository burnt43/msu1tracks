class AddFilenamePrefixToMsu1Patches < ActiveRecord::Migration[5.2]
  def change
    add_column(:msu1_patches, :filename_prefix, :string, null: false)
  end
end
