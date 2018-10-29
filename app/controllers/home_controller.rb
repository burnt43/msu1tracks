class HomeController < ApplicationController
  def index
    @msu1_pcm_tracks = Msu1PcmTrack.all.includes(videogame: [:console]).order(:filename)
  end
end
