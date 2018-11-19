class Msu1PacksController < ApplicationController
  def download
    @msu1_pack = Msu1Pack.find_by(id: params[:id])

    temp_zip_file = @msu1_pack.create_archive_for_music_tracks!
    cookies[:archive_complete] = 'yes'
    send_file(temp_zip_file, filename: "#{@msu1_pack.name_for_archived_music_tracks}.zip")
  end
end
