class Console < ApplicationRecord
  include SyncFromYaml

  # associations
  has_many :videogames
  has_many :music_tracks, through: :videogames

  # scope
  scope :has_videogames_with_music_tracks, -> { self.joins(videogames: [:music_tracks]).group(:id).having("COUNT(*) > 1") }
  
  # instance methods
  def to_s
    "#<#{self.class.name} id:\033[0;35m#{self.id}\033[0;0m friendly_name:\033[0;35m#{self.friendly_name}\033[0;0m>"
  end

  # SyncFromYaml
  define_active_record_to_yaml_attributes_map :friendly_name, :friendly_name

  self.indexed_objects_for_yaml_sync = ->{
    self.all_indexed_by(:name)
  }

  def self.sync_manifest_with_database
    self.transaction {
      # add/update
      (self.yaml_manifest.dig('consoles') || Hash.new).each {|console_name, console_config|
        if console = self.indexed_objects_for_yaml_sync[console_name]
          console.update_attributes_from_yaml(console_config)
        else
          self.create_from_yaml({name: console_name}, console_config)
        end
      }
    }
  end
end # Console 
