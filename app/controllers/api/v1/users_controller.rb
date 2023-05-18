# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :set_user, except: %i[create index]
  skip_before_action :authenticate_user, only: :create
  before_action :ensure_account_ownership, only: %i[update destroy]

  # GET /api/v1/users
  def index
    @pagy, @records = pagy(User.all)
    render json: @records, status: 200, each_serializer: UserSerializer
  end

  # GET api/v1/users/{username}
  def show
    render json: @user, status: 200, serializer: UserSerializer if @user
  end

  # POST api/v1/users
  def create
    @user = User.new(user_params_for_create)
    if @user.save
      render json: @user, status: 201, serializer: UserSerializer
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  # PATCH api/v1/users/{username}
  def update
    if @user.update(user_params_for_update)
      render json: @user, status: 200, serializer: UserSerializer
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  # DELETE api/v1/users/{username}
  def destroy
    @user&.destroy
    head :no_content
  end

  private

  def user_params_for_create
    params.require(:user).permit(%i[name username email password password_confirmation])
  end

  def user_params_for_update
    params.require(:user).permit(:name)
  end


  def set_user
    @user = User.find_by_username(params[:_username]) or not_found('user')
  end

  def ensure_account_ownership
    render json: { errors: 'You are not allowed to do this' }, status: 401 unless authenticate_user == set_user
  end
end
