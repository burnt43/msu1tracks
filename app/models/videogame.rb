class Videogame < ApplicationRecord
  include SyncFromYaml
  include ArchivedMusicTracks

  # associations
  belongs_to :console
  has_many :music_tracks

  # scope
  scope :latest_n_changed, ->(n) { joins(:music_tracks).group(:id).order("MAX(`#{MusicTrack.table_name}`.`updated_at`)").limit(n) }

  # instance methods
  def to_s
    "#<#{self.class.name} id:\033[0;35m#{self.id}\033[0;0m console.friendly_name:\033[0;35m#{self.console.friendly_name}\033[0;0m friendly_name:\033[0;35m#{self.friendly_name}\033[0;0m>"
  end

  def most_recently_updated_music_track
    if self.music_tracks.loaded?
      self.music_tracks.max_by {|music_track| music_track.updated_at}
    else
      self.music_tracks.order(updated_at: :desc).first
    end
  end

  # SyncFromYaml
  define_active_record_to_yaml_attributes_map :friendly_name, :friendly_name

  self.indexed_objects_for_yaml_sync = ->{
    self.all_indexed_by({console: :name}, :name)
  }

  def self.sync_manifest_with_database
    Console.indexed_objects_for_yaml_sync(reload: true)

    self.transaction {
      # add/update
      (self.yaml_manifest.dig('consoles') || Hash.new).each {|console_name, console_config|
        (console_config.dig('videogames') || Hash.new).each {|videogame_name, videogame_config|
          if videogame = self.indexed_objects_for_yaml_sync.dig(console_name, videogame_name)
            videogame.update_attributes_from_yaml(videogame_config)
          else
            self.create_from_yaml({name: videogame_name, console: Console.indexed_objects_for_yaml_sync.dig(console_name)}, videogame_config)
          end
        }
      }
    }
  end

  # ArchivedMusicTracks
  alias_attribute :name_for_archived_music_tracks, :name

  def archived_music_track_mapping
    Hash[self.music_tracks.map {|music_track|
      [music_track.filename, music_track.pathname.to_s]
    }]
  end
end # Videogame 
