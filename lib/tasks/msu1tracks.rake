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

  task :sync_msu1_patches => [:environment] do
    set_logger
    Msu1Patch.sync_manifest_with_database
  end

  task :sync_msu1_patch_tracks => [:environment] do
    set_logger
    Msu1Patch::Track.sync_manifest_with_database
  end

  task :sync_msu1_packs => [:environment] do
    set_logger
    Msu1Pack.sync_manifest_with_database
  end

  task :sync_msu1_pack_mappings => [:environment] do
    set_logger
    Msu1Pack::Mapping.sync_manifest_with_database
  end

  task :sync_music_files_with_database=> [:environment] do
    set_logger
    MusicTrack.children.each(&:sync_files_with_database)
  end

  task :sync_all => [:sync_consoles, :sync_videogames, :sync_msu1_patches, :sync_msu1_patch_tracks, :sync_msu1_packs, :sync_msu1_pack_mappings, :sync_music_files_with_database]
end
