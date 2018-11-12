class Msu1PcmTrack < MusicTrack
  self.sub_directory_name = 'pcm'
  self.file_extension     = 'pcm'

  # SyncFromYaml
  self.indexed_objects_for_yaml_sync = ->{
    self.all_indexed_by({console: :name}, {videogame: :name}, :filename)
  }
end
