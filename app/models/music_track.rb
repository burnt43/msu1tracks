class MusicTrack < ApplicationRecord
  # associations
  belongs_to :videogame
  has_one :console, through: :videogame

  # class methods
  def self.parent_directory
    Pathname.new(Rails.configuration.x.music_files.dir)
  end

  def self.sub_directory_name=(value)
    @sub_directory_name= value
  end
  def self.sub_directory_name
    @sub_directory_name
  end

  def self.file_extension=(value)
    @file_extension = value
  end
  def self.file_extension
    @file_extension
  end

  def self.children
    [Msu1PcmTrack]
  end

  def self.sync_files_with_database
    music_track_directory = self.parent_directory
    filenames             = Dir[music_track_directory.join('*', '*', self.sub_directory_name, "*.#{self.file_extension}")]

    videogame_cache   = Videogame.all_indexed_by({console: :name}, :name)
    music_track_cache = Msu1PcmTrack.all_indexed_by({console: :name}, {videogame: :name}, :filename)
    
    self.transaction {
      # make sure each music_track in the database is on the filesystem
      self.all.each {|music_track|
        unless music_track.pathname.exist?
          music_track.destroy
          Rails.logger.info "\033[0;31mdestroying\033[0;0m #{music_track.to_s}"
        end
      }

      # make sure each file on the filesystem has a music_track in the database
      filenames.each {|filename|
        filename_without_prefix = filename.sub(/^#{music_track_directory.to_s}/, '')
        filename_parts          = filename_without_prefix.split('/')

        console_name         = filename_parts[1]
        videogame_name       = filename_parts[2]
        music_track_filename = Pathname.new(filename).basename(".#{self.file_extension}").to_s

        unless music_track_cache.dig(console_name, videogame_name, music_track_filename)
          new_music_file = self.create(
            filename:  music_track_filename,
            videogame: videogame_cache.dig(console_name, videogame_name),
          )
          Rails.logger.info "\033[0;32mcreating\033[0;0m #{new_music_file.to_s}"
        end
      }
    }
  end

  # instance methods
  def pathname
    self.class.parent_directory.join(self.console.name, self.videogame.name, self.class.sub_directory_name, self.filename_with_extension)
  end

  def filename_with_extension
    "#{self.filename}.#{self.file_extension}"
  end

  def file_extension
    self.class.file_extension
  end

  def binary_data
    file = File.open(self.pathname, 'r')
    data = file.read
    file.close

    data
  end

  def to_s
    "#<#{self.class.name} console.friendly_name:\033[0;35m#{self.console.friendly_name}\033[0;0m videogame.friendly_name:\033[0;35m#{self.videogame.friendly_name}\033[0;0m filename:\033[0;35m#{self.filename}.#{self.class.file_extension}\033[0;0m>"
  end
end
