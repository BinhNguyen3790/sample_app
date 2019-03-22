class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_resets][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t("controllers.password_resets.send")
      redirect_to root_path
    else
      flash.now[:danger] = t("controllers.password_resets.error")
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("controllers.password_resets.empty"))
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t("controllers.password_resets.success")
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
  end

  # Confirms a valid user.
  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_path
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t("controllers.password_resets.expired")
    redirect_to new_password_reset_url
  end
end
