class VideogamesController < ApplicationController
  def show
    @videogame = Videogame.find(params[:id])
  end

  def download_music_tracks
    @videogame = Videogame.find(params[:id])

    temp_zip_file = @videogame.create_archive_or_music_tracks!
    send_data(temp_zip_file.read, filename: temp_zip_file.to_path)
  end
end
