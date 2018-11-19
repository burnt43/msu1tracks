module ArchivedMusicTracks
  extend ActiveSupport::Concern

  def name_for_archived_music_tracks
    raise 'Implement in Class!'
  end

  def archived_music_track_mapping
    raise 'Implement in Class!'
  end

  def create_archive_for_music_tracks!
    tempfile = Tempfile.new([self.name_for_archived_music_tracks, '.zip'])
    
    Zip::File.open(tempfile.to_path, Zip::File::CREATE) {|zipfile|
      self.archived_music_track_mapping.each {|filename, pathname|
        zipfile.add(filename, pathname)
      }
    }

    tempfile
  end
end
