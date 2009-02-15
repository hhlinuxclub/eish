class AboutController < ApplicationController
  skip_before_filter :authorize
end
