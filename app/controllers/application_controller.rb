class ApplicationController < ActionController::Base

  def per_page_value
    params[:limit] || 25
  end

  def page_number
    params[:page] || 1
  end
end
