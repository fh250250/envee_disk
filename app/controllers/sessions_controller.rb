class SessionsController < ApplicationController

  before_action :require_login, only: [:destroy]
  before_action :require_logout, only: [:new, :create]

  def new
    @login_form = LoginForm.new
  end

  def create
    @login_form = LoginForm.new login_form_params

    if user = @login_form.submit
      login user, @login_form.remember_me
      flash[:success] = "登录成功，#{user.username} 欢迎回来"
      redirect_to root_path
    else
      flash.now[:error] = "登录失败，账号或密码错误"
      render :new
    end
  end

  def destroy
    logout
    flash[:notice] = "已退出登录"
    redirect_to login_path
  end

  private

  def login_form_params
    params.require(:login_form).permit(:username, :password, :remember_me)
  end

end
