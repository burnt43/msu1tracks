class MusicTrack < ApplicationRecord
  # associations
  belongs_to :videogame

  # class methods
  def self.console_videogame_music_file_3_tuples
    self.all.joins(:videogame).merge(Videogame.joins(:console)).pluck("#{Console.table_name}.name, #{Videogame.table_name}.name, #{self.table_name}.filename").to_set
  end
end
