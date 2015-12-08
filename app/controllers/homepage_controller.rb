class HomepageController < ApplicationController
  before_action :require_login, except: [:index]

  def index
    if signed_in?
      render :index
    else
      render :welcome
    end
  end
end
