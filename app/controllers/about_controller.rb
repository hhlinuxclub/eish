class AboutController < ApplicationController
  def index
    @about = Setting.option("about")
  end
end
