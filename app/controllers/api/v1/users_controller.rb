# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user, only: :create
  before_action :set_user, except: %i[create index]
  before_action :correct_user, only: %i[edit update destroy]

  # GET /api/v1/users
  def index
    @pagy, @records = pagy(User.all)
    render json: @records, status: 200, each_serializer: UserSerializer
  end

  # GET api/v1/users/{username}
  def show
    render json: @user, status: 200, serializer: UserSerializer
  end

  # POST api/v1/users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: 201, serializer: UserSerializer
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  # PUT api/v1/users/{username}
  def update
    if @user&.update(user_params)
      render json: @user, serializer: UserSerializer
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  # DELETE api/v1/users/{username}
  def destroy
    @user.destroy
    head :no_content
  end

  private

  def user_params
    params.permit(%i[name username email password password_confirmation])
  end

  def set_user
    @user = User.find_by_username!(params[:username])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: 404
  end

  def correct_user
    render json: { errors: 'You are not allowed to do this' }, status: 401 unless authenticate_user == set_user
  end
end
