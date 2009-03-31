class DashboardsController < ApplicationController
  
  def show
    @chart = FlashChart.new('caerus.swf', :title => "My First Chart")
  end
  
end
