class MetaFilesController < ApplicationController

  before_action :require_login
  before_action :set_meta_file
  before_action :ensure_user_meta_file

  def show
  end

  def edit
  end

  def update
    if @meta_file.update(meta_file_params)
      redirect_to @meta_file, notice: "已修改文件"
    else
      render :edit
    end
  end

  def destroy
    @meta_file.destroy
    redirect_to @meta_file.folder, notice: "文件已删除 #{@meta_file.name}"
  end

  def move
    load_user_folders
  end

  def perform_move
    folder = Folder.find params[:meta_file][:folder_id]

    if folder.user_id != current_user.id
      flash[:error] = "无权移动文件"
      redirect_to(@meta_file) and return
    end

    if @meta_file.update(folder: folder)
      redirect_to folder, notice: "文件已移动"
    else
      load_user_folders
      render :move
    end
  end

  private

  def set_meta_file
    @meta_file = MetaFile.find params[:id]
  end

  def ensure_user_meta_file
    if @meta_file.folder.user_id != current_user.id
      flash[:error] = "无权操作此文件"
      redirect_to root_path
    end
  end

  def meta_file_params
    params.require(:meta_file).permit(:name)
  end

  def load_user_folders
    @folders = current_user.folders.order(:lft)
  end

end
