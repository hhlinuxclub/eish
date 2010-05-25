class GalleriesController < ApplicationController
  def index
    @galleries = Gallery.published.not_null
    @columns = 4 # TODO: Move this to the settings table
    
    respond_to do |format|
        format.html
    end
  end

  def show
    @gallery = Gallery.published.find(params[:id].to_i)
    @columns = 4 # TODO: Move this to the settings table
    
    respond_to do |format|
        format.html
    end
  end
end
