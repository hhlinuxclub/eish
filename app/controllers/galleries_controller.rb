class GalleriesController < ApplicationController
  
  def index
      @galleries = Gallery.find_all_by_published(true, :conditions => "image_id IS NOT NULL", :order => "published_at DESC")
      @columns = 4 # TODO: Move this to the settings table
      
      respond_to do |format|
          format.html
      end
  end

  def show
      @gallery = Gallery.find_by_id_and_published(params[:id].to_i, true)
      @columns = 4 # TODO: Move this to the settings table
      
      respond_to do |format|
          format.html
      end
  end
end
