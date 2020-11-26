class FoldersController < ApplicationController

  before_action :require_login
  before_action :set_folder
  before_action :ensure_user_folder
  before_action :ensure_not_root_folder, only: [:move, :perform_move, :edit, :update, :destroy]

  def make
    @new_folder = Folder.new
  end

  def perform_make
    @new_folder = Folder.new folder_params
    @new_folder.user = current_user
    @new_folder.parent = @folder

    if @new_folder.save
      redirect_to @folder, notice: "已创建目录 #{@new_folder.name}"
    else
      render :make
    end
  end

  def move
    load_user_folders
  end

  def perform_move
    if @folder.update(params.require(:folder).permit(:parent_id))
      redirect_to @folder, notice: "目录已移动"
    else
      load_user_folders
      render :move
    end
  end

  def upload
  end

  def perform_upload
    if blob = Blob.find_by(sha256: params[:sha256])
      @meta_file = MetaFile.create_with_name_retry(params[:name], @folder, blob)

      unless @meta_file.errors.any?
        flash[:notice] = "上传文件成功 #{@meta_file.name}"
      end

      render("meta_files/show", formats: :json) and return
    end

    unless @upload = @folder.uploads.find_by(sha256: params[:sha256])
      @upload = @folder.uploads.build name: params[:name],
                                      sha256: params[:sha256],
                                      size: params[:size],
                                      part_size: params[:part_size]
      @upload.save
    end

    render("uploads/show", formats: :json)
  end

  def show
  end

  def edit
  end

  def update
    if @folder.update(folder_params)
      redirect_to @folder, notice: "已修改目录"
    else
      render :edit
    end
  end

  def destroy
    if @folder.can_destroy?
      @folder.destroy!
      redirect_to @folder.parent, notice: "目录已删除 #{@folder.name}"
    else
      flash[:error] = "当前目录非空，无法删除"
      redirect_to @folder
    end
  end

  private

  def set_folder
    @folder = Folder.find params[:id]
  end

  def ensure_user_folder
    if @folder.user_id != current_user.id
      flash[:error] = "无权操作此目录"
      redirect_to root_path
    end
  end

  def ensure_not_root_folder
    if @folder.root?
      flash[:error] = "无权操作此目录"
      redirect_to root_path
    end
  end

  def folder_params
    params.require(:folder).permit(:name)
  end

  def load_user_folders
    @folders = current_user.folders.order(:lft)
  end

end
