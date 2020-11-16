concern :SessionsConcern do

  included do
    helper_method :current_user
  end

  protected

  def current_user
    return @_current_user if @_current_user

    if user_id = current_user_id
      @_current_user = User.find(user_id)
    end

    @_current_user
  end

  def login(user, remember_me = false)
    session[:current_user_id] = user.id

    if remember_me
      cookies.encrypted[:current_user_id] = {
        value: user.id,
        expires: 7.days
      }
    end

    @_current_user = user
  end

  def logout
    session.delete :current_user_id
    cookies.delete :current_user_id
    @_current_user = nil
  end

  def require_login
    unless current_user
      flash[:error] = "当前未登录，请先登录"
      redirect_to login_path
    end
  end

  def require_logout
    if current_user
      flash[:error] = "当前已登录，请先退出"
      redirect_to root_path
    end
  end

  private

  def current_user_id
    user_id = session[:current_user_id]

    unless user_id
      user_id = cookies.encrypted[:current_user_id]

      if user_id
        session[:current_user_id] = user_id
      end
    end

    user_id
  end

end
