class MusicTracksController < ApplicationController
  def download
    @music_track = MusicTrack.find(params[:id])

    send_data(@music_track.binary_data, filename: @music_track.filename_with_extension)
  end
end
