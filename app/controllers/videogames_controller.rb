class VideogamesController < ApplicationController
  def show
    @videogame = Videogame.find(params[:id])
  end

  def download_music_tracks
    @videogame = Videogame.find(params[:id])

    temp_zip_file = @videogame.create_archive_or_music_tracks!
    cookies[:archive_complete] = 'yes'
    send_file(temp_zip_file, filename: "#{@videogame.name}.zip")
  end
end
