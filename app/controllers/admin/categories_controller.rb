class Admin::CategoriesController < ApplicationController
  def create
    @category = Category.create!(params[:category])
    
    respond_to do |format|
      format.js
    end
  end
end
