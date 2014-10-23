class WelcomeController < ApplicationController
  def index
    #@registries = Registry.find(:all, :include => [:statistics_version, :statistics_summary])
    @registries = Registry.all
    @records    = Statistics::Record.new
    @countries  = Country.all
  end
end
