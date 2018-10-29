namespace :msu1tracks do
  task :sync_consoles => [:environment] do
    Rails.logger = Logger.new(STDOUT)
    Console.sync_manifest_with_database
  end

  task :sync_videogames => [:environment] do
    Rails.logger = Logger.new(STDOUT)
    Videogame.sync_manifest_with_database
  end

  task :sync_files_with_database=> [:environment] do
    Rails.logger = Logger.new(STDOUT)
    Msu1PcmTrack.sync_files_with_database
  end

  task :sync_all => [:sync_consoles, :sync_videogames, :sync_files_with_database]
end
