namespace :msu1tracks do
  def set_logger
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.level = Logger::INFO
    Rails.logger.formatter = proc {|severity, datetime, progname, msg|
      "#{msg}\n"
    }
  end

  task :sync_consoles => [:environment] do
    set_logger
    Console.sync_manifest_with_database
  end

  task :sync_videogames => [:environment] do
    set_logger
    Videogame.sync_manifest_with_database
  end

  task :sync_music_files_with_database=> [:environment] do
    set_logger
    MusicTrack.children.each(&:sync_files_with_database)
  end

  task :sync_all => [:sync_consoles, :sync_videogames, :sync_music_files_with_database]
end
