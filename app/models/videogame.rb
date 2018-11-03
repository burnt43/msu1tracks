class Videogame < ApplicationRecord
  include SyncFromYaml

  # associations
  belongs_to :console
  has_many :music_tracks

  # scopes
  default_scope { includes(:console) }

  # instance methods
  def to_s
    "#<#{self.class.name} id:#{self.id} console.friendly_name:#{self.console.friendly_name} friendly_name:#{self.friendly_name}>"
  end

  # SyncFromYaml
  define_active_record_to_yaml_attributes_map :friendly_name, :friendly_name

  self.indexed_objects_for_yaml_sync = ->{
    self.all_indexed_by({console: :name}, :name)
  }

  def self.sync_manifest_with_database
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
end # Videogame 
