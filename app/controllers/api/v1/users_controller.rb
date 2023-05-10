# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, except: :create
  before_action :set_user, except: %i[create index]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: 200
  end

  # GET /users/{username}
  def show
    render json: @user, status: 200
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: 201
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  # PUT /users/{username}
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  # DELETE /users/{username}
  def destroy
    @user.destroy
  end

  private

  def user_params
    params.permit(%i[name username email password password_confirmation])
  end

  def set_user
    @user = User.find_by_username!(params[:_username])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: 404
  end
end
