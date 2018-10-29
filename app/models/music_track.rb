class MusicTrack < ApplicationRecord
  # associations
  belongs_to :videogame

  # class methods
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

  def self.console_videogame_music_file_3_tuples
    self.all.joins(:videogame).merge(Videogame.joins(:console)).pluck("#{Console.table_name}.name, #{Videogame.table_name}.name, #{self.table_name}.filename").to_set
  end
end
