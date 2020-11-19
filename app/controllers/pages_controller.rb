class PagesController < ApplicationController

  before_action :require_login

  def index
    redirect_to folder_path(current_user.folders.root)
  end

end
