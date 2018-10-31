class Videogame < ApplicationRecord
  # associations
  belongs_to :console

  # scopes
  default_scope { includes(:console) }

  # class methods
  def self.manifest_pathname
    Rails.root.join('config', 'msu1tracks', 'videogame_manifest.yml')
  end

  def self.sync_manifest_with_database
    yaml            = YAML.load(IO.read(self.manifest_pathname))
    videogame_cache = Videogame.all_indexed_by({console: :name}, :name)
    console_cache   = Hash.new

    self.transaction {
      (yaml.dig('consoles') || Hash.new).each {|console_name, console_config|
        (console_config.dig('videogames') || Hash.new).each {|videogame_name, videogame_config|
          unless videogame_cache.dig(console_name, videogame_name)
            new_videogame = self.create(
              name:          videogame_name,
              friendly_name: videogame_config['friendly_name'], 
              console:       console_cache[console_name] ||= Console.find_by(name: console_name),
            )
            Rails.logger.info "\033[0;32mcreating\033[0;0m #{new_videogame.to_s}"
          end
        }
      }
    }
  end

  # instance methods
  def to_s
    "#<#{self.class.name} #{self.console.friendly_name}/#{self.friendly_name}>"
  end
end
