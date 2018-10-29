class Videogame < ApplicationRecord
  # associations
  belongs_to :console

  # class methods
  def self.manifest_pathname
    Rails.root.join('config', 'msu1tracks', 'videogame_manifest.yml')
  end

  def self.console_name_videogame_name_pairs
    self.all.joins(:console).pluck("#{Console.table_name}.name, #{Videogame.table_name}.name").to_set
  end

  def self.sync_manifest_with_database
    yaml                                = YAML.load(IO.read(Videogame.manifest_pathname))
    set_of_console_videogame_name_pairs = self.console_name_videogame_name_pairs
    console_cache                       = Hash.new

    Videogame.transaction {
      (yaml.dig('consoles') || Hash.new).each {|console_name, console_config|
        (console_config.dig('videogames') || Hash.new).each {|videogame_name, videogame_config|
          unless set_of_console_videogame_name_pairs.member?([console_name, videogame_name])
            new_videogame = Videogame.create(
              name:          videogame_name,
              friendly_name: videogame_config['friendly_name'], 
              console:       console_cache[console_name] ||= Console.find_by(name: console_name),
            )
            Rails.logger.info "\033[0;32mcreating\033[0;0m #{new_videogame.attributes.to_s}"
          end
        }
      }
    }
  end
end
