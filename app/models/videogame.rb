class Videogame < ApplicationRecord
  include SyncFromYaml
  include ArchivedMusicTracks

  # associations
  belongs_to :console

  has_many :msu1_pcm_tracks
  has_many :msu1_packs

  # scope
  scope :ordered_by_having_most_recently_updated_msu1_pcm_tracks, ->() { 
    joins(:msu1_pcm_tracks).group(:id).order("MAX(`#{MusicTrack.table_name}`.`updated_at`) DESC") 
  }

  # instance methods
  def to_s
    "#<#{self.class.name} id:\033[0;35m#{self.id}\033[0;0m console.friendly_name:\033[0;35m#{self.console.friendly_name}\033[0;0m friendly_name:\033[0;35m#{self.friendly_name}\033[0;0m>"
  end

  def most_recently_updated_msu1_pcm_track
    if self.msu1_pcm_tracks.loaded?
      self.msu1_pcm_tracks.max_by {|msu1_pcm_track| msu1_pcm_track.updated_at}
    else
      self.msu1_pcm_tracks.order(updated_at: :desc).first
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
          attributes = {
            name:    videogame_name,
            console: Console.indexed_objects_for_yaml_sync.dig(console_name),
          }

          if videogame = self.indexed_objects_for_yaml_sync.dig(console_name, videogame_name)
            videogame.update_attributes_from_yaml(attributes, videogame_config)
          else
            self.create_from_yaml(attributes, videogame_config)
          end
        }
      }
    }
  end

  # ArchivedMusicTracks
  alias_attribute :name_for_archived_music_tracks, :name

  def archived_music_track_mapping
    Hash[self.msu1_pcm_tracks.map {|music_track|
      [music_track.filename, music_track.pathname.to_s]
    }]
  end
end # Videogame 
