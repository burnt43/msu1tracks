class Msu1Patch < ApplicationRecord
  include SyncFromYaml

  # associations
  belongs_to :videogame
  has_one :console, through: :videogame

  # instance methods
  def to_s
    "#<#{self.class.name} id:\033[0;35m#{self.id}\033[0;0m videogame.friendly_name:\033[0;35m#{self.videogame.friendly_name}\033[0;0m friendly_name:\033[0;35m#{self.friendly_name}\033[0;0m>"
  end

  # SyncFromYaml
  define_active_record_to_yaml_attributes_map :friendly_name, :friendly_name
  define_active_record_to_yaml_attributes_map :filename_prefix, :filename_prefix

  self.indexed_objects_for_yaml_sync = ->{
    self.all_indexed_by({console: :name}, {videogame: :name}, :name)
  }

  def self.sync_manifest_with_database
    Videogame.indexed_objects_for_yaml_sync(reload: true)

    self.transaction {
      # add/update
      (self.yaml_manifest.dig('consoles') || Hash.new).each {|console_name, console_config|
        (console_config.dig('videogames') || Hash.new).each {|videogame_name, videogame_config|
          (videogame_config.dig('msu1_patches') || Hash.new).each {|msu1_patch_name, msu1_patch_config|
            attributes = {
              name:      msu1_patch_name, 
              videogame: Videogame.indexed_objects_for_yaml_sync.dig(console_name, videogame_name),
            }

            if msu1_patch = self.indexed_objects_for_yaml_sync.dig(console_name, videogame_name, msu1_patch_name)
              msu1_patch.update_attributes_from_yaml(attributes, msu1_patch_config)
            else
              self.create_from_yaml(attributes, msu1_patch_config)
            end
          }
        }
      }
    }
  end

  # classes
  class Track < ApplicationRecord
    include SyncFromYaml

    # associations
    belongs_to :msu1_patch
    has_one :videogame, through: :msu1_patch
    has_one :console, through: :videogame

    # SyncFromYaml
    define_active_record_to_yaml_attributes_map :friendly_name, :friendly_name

    self.indexed_objects_for_yaml_sync = ->{
      self.all_indexed_by({console: :name}, {videogame: :name}, {msu1_patch: :name}, :track_number)
    }

    def self.sync_manifest_with_database
      Msu1Patch.indexed_objects_for_yaml_sync(reload: true)

      self.transaction {
        # add/update
        (self.yaml_manifest.dig('consoles') || Hash.new).each {|console_name, console_config|
          (console_config.dig('videogames') || Hash.new).each {|videogame_name, videogame_config|
            (videogame_config.dig('msu1_patches') || Hash.new).each {|msu1_patch_name, msu1_patch_config|
              (msu1_patch_config.dig('tracks') || Hash.new).each {|msu1_patch_track_track_number, msu1_patch_track_config|
                attributes = {
                  track_number: msu1_patch_track_track_number, 
                  msu1_patch:   Msu1Patch.indexed_objects_for_yaml_sync.dig(console_name, videogame_name, msu1_patch_name),
                }

                if msu1_patch_track = self.indexed_objects_for_yaml_sync.dig(console_name, videogame_name, msu1_patch_name, msu1_patch_track_track_number)
                  msu1_patch_track.update_attributes_from_yaml(attributes, msu1_patch_track_config)
                else
                  self.create_from_yaml(attributes, msu1_patch_track_config)
                end
              }
            }
          }
        }
      }
    end

    # instance methods
    def to_s
      "#<#{self.class.name} id:\033[0;35m#{self.id}\033[0;0m videogame.friendly_name:\033[0;35m#{self.videogame.friendly_name}\033[0;0m msu1_patch.friendly_name:\033[0;35m#{msu1_patch.friendly_name}\033[0;0m track_number:\033[0;35m#{self.track_number}\033[0;0m friendly_name:\033[0;35m#{self.friendly_name}\033[0;0m>"
    end
  end
end
