# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, except: :create
  before_action :set_user, except: %i[create index]

  # GET /api/v1/users
  def index
    @pagy, @records = pagy(User.all)
    render json: @records, status: 200
  end

  # GET api/v1/users/{username}
  def show
    render json: @user, status: 200
  end

  # POST api/v1/users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: 201
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  # PUT api/v1/users/{username}
  def update
    render json: { errors: @user.errors.full_messages }, status: 422 unless @user&.update(user_params)
    render json: @user
  end

  # DELETE api/v1/users/{username}
  def destroy
    render json: { errors: @user.errors.full_messages }, status: 422 unless @user&.destroy
    render json: { notice: 'User was successfully deleted' }
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
