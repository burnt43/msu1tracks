class Console < ApplicationRecord
  # associations
  has_many :videogames
  has_many :music_tracks, through: :videogames
  
  # class methods
  def self.sync_manifest_with_database
    yaml          = YAML.load(IO.read(Videogame.manifest_pathname))
    console_cache = Console.all_indexed_by(:name)

    self.transaction {
      (yaml.dig('consoles') || Hash.new).each {|console_name, console_config|
        unless console_cache.has_key?(console_name)
          new_console = self.create(name: console_name, friendly_name: console_config['friendly_name'])
          Rails.logger.info "\033[0;32mcreating\033[0;0m #{new_console.to_s}"
        end
      }
    }
  end

  # instance methods
  def to_s
    "#<#{self.class.name} #{self.friendly_name}>"
  end
end
