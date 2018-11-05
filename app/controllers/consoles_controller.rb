class ConsolesController < ApplicationController
  def show
    @console = Console.find(params[:id])
    @console.videogames.includes(:music_tracks)
  end
end
