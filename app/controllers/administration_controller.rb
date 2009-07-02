class AdministrationController < ApplicationController
  include Authorization::Filters
  before_filter :authorize
  before_filter :check_create_privileges, :only => [:new, :create]
  layout "admin"
end
