class MusicTracksController < ApplicationController
  def download
    @music_track = MusicTrack.find(params[:id])

    send_file(@music_track.pathname, filename: @music_track.filename_with_extension)
  end
end
