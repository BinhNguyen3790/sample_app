class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user&.authenticate(params[:session][:password])
      log_in @user
      if params[:session][:remember_me] == Settings.sessions.number
        remember @user
      else
        forget @user
      end
      redirect_to @user
    else
      flash.now[:danger] = t "controllers.sessions.messenger"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user
    flash.now[:danger] = t "not_found"
    render :new
  end
end
