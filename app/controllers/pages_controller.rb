class PagesController < ApplicationController

  before_action :require_login

  def index
    @folder = current_user.folders.root
  end

end
