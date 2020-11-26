class UploadsController < ApplicationController

  before_action :require_login
  before_action :set_upload
  before_action :ensure_user_upload

  def part
    if @upload.is_completed?
      render json: {errors: ["当前上传任务已完成"]} and return
    end

    unless @upload.save_part_from params[:part].path
      render json: {errors: ["存储分块文件失败"]} and return
    end

    unless @upload.is_completed?
      render(:show, formats: :json) and return
    end

    if blob = @upload.merge_parts_to_blob
      @meta_file = MetaFile.create_with_name_retry(@upload.name, @upload.folder, blob)
      @upload.destroy

      unless @meta_file.errors.any?
        flash[:notice] = "上传文件成功 #{@meta_file.name}"
      end

      render "meta_files/show", formats: :json
    else
      render json: {errors: ["合并分块失败"]}
    end
  end

  private

  def set_upload
    @upload = Upload.find params[:id]
  end

  def ensure_user_upload
    if @upload.folder.user_id != current_user.id
      render json: {errors: ["无权操作此上传任务"]}
    end
  end

end
