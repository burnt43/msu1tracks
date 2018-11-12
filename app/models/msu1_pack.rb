class Msu1Pack < ApplicationRecord
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

  self.indexed_objects_for_yaml_sync = ->{
    self.all_indexed_by({console: :name}, {videogame: :name}, :name)
  }

  def self.sync_manifest_with_database
    Msu1Pack.indexed_objects_for_yaml_sync(reload: true)

    self.transaction {
      # add/update
      (self.yaml_manifest.dig('consoles') || Hash.new).each {|console_name, console_config|
        (console_config.dig('videogames') || Hash.new).each {|videogame_name, videogame_config|
          (videogame_config.dig('msu1_packs') || Hash.new).each {|msu1_pack_name, msu1_pack_config|
            if msu1_pack = self.indexed_objects_for_yaml_sync.dig(console_name, videogame_name, msu1_pack_name)
              msu1_pack.update_attributes_from_yaml(msu1_pack_config)
            else
              self.create_from_yaml({name: msu1_pack_name, videogame: Videogame.indexed_objects_for_yaml_sync.dig(console_name, videogame_name)}, msu1_pack_config)
            end
          }
        }
      }
    }
  end

  # classes
  class Mapping < ApplicationRecord
    include SyncFromYaml

    # associations
    belongs_to :msu1_pack
    belongs_to :msu1_pcm_track
    belongs_to :msu1_patch_track, class_name: 'Msu1Patch::Track'

    has_one :console, through: :videogame

    # instance methods
    def to_s
      "#<#{self.class.name} id:\033[0;35m#{self.id}\033[0;0m msu1_pack.friendly_name:\033[0;35m#{self.msu1_pack.friendly_name}\033[0;0m msu1_patch_track.friendly_name:\033[0;35m#{self.msu1_patch_track.friendly_name}\033[0;0m msu1_pcm_track.filename:\033[0;35m#{self.msu1_pcm_track.filename}\033[0;0m>"
    end

    # SyncFromYaml
    self.indexed_objects_for_yaml_sync = ->{
      self.all_indexed_by({console: :name}, {videogame: :name}, {msu1_pack: :name}, :track_number)
    }

    def self.sync_manifest_with_database
      Msu1Pack::Mapping.indexed_objects_for_yaml_sync(reload: true)

      self.transaction {
        # add/update
        (self.yaml_manifest.dig('consoles') || Hash.new).each {|console_name, console_config|
          (console_config.dig('videogames') || Hash.new).each {|videogame_name, videogame_config|
            (videogame_config.dig('msu1_packs') || Hash.new).each {|msu1_pack_name, msu1_pack_config|
              (msu1_pack_config.dig('mapping') || Hash.new).each {|mapping_track_number, mapping_config|
                if msu1_patch_mapping = self.indexed_objects_for_yaml_sync.dig(console_name, videogame_name, msu1_pack_name, mapping_track_number)
                  msu1_patch_mapping.update_attributes_from_yaml(mapping_config)
                else
                  foo = self.create_from_yaml({
                    track_number:     mapping_track_number, 
                    msu1_pack:        Msu1Pack.indexed_objects_for_yaml_sync.dig(console_name, videogame_name, msu1_pack_name), 
                    msu1_patch_track: Msu1Patch::Track.indexed_objects_for_yaml_sync.dig(console_name, videogame_name, msu1_pack_config['patch'], mapping_track_number),
                    msu1_pcm_track:   Msu1PcmTrack.indexed_objects_for_yaml_sync.dig(mapping_config['console'], mapping_config['videogame'], mapping_config['track']),
                  }, mapping_config)
                end
              }
            }
          }
        }
      }
    end
  end # Mapping
end # Msu1Pack
