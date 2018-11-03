class Msu1Patch < ApplicationRecord
  include SyncFromYaml

  # associations
  belongs_to :videogame

  class Track < ApplicationRecord
    include SyncFromYaml

    # associations
    belongs_to :msu1_patch
  end
end
