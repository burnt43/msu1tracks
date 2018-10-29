class Console < ApplicationRecord
  
  # class methods
  def self.set_of_names
    self.all.pluck(:name).to_set
  end

  def self.sync_manifest_with_database
    yaml                 = YAML.load(IO.read(Videogame.manifest_pathname))
    set_of_console_names = self.set_of_names

    Console.transaction {
      (yaml.dig('consoles') || Hash.new).each {|console_name, console_config|
        unless set_of_console_names.member?(console_name)
          new_console = Console.create(name: console_name, friendly_name: console_config['friendly_name'])
          Rails.logger.info "\033[0;32mcreating\033[0;0m #{new_console.attributes.to_s}"
        end
      }
    }
  end
end
