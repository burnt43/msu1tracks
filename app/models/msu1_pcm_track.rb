class Msu1PcmTrack < MusicTrack
  def self.sync_files_with_database
    music_file_dir = Pathname.new(Rails.configuration.x.music_files.dir)
    filenames      = Dir[music_file_dir.join('**', '*.pcm')]

    videogame_cache      = Videogame.all_indexed_by(:name, parent_index: {console: :name})
    music_files_3_tuples = self.console_videogame_music_file_3_tuples
    
    self.transaction {
      filenames.each {|filename|
        filename_without_prefix = filename.sub(/^#{music_file_dir.to_s}/, '')
        filename_parts          = filename_without_prefix.split('/')

        console_name   = filename_parts[1]
        videogame_name = filename_parts[2]
        music_filename = Pathname.new(filename).basename('.pcm').to_s

        unless music_files_3_tuples.member?([console_name, videogame_name, music_filename])
          new_music_file = self.create(
            filename:  music_filename,
            videogame: videogame_cache.dig(console_name, videogame_name),
          )
          Rails.logger.info "\033[0;32mcreating\033[0;0m #{new_music_file.attributes.to_s}"
        end
      }
    }
  end
end
