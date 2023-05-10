# frozen_string_literal: true

class Api::V1::AuthenticationController < ApplicationController
  include JsonWebToken

  skip_before_action :authenticate_user

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime('%d-%m-%Y %H:%M'),
                     username: @user.username }, status: 200
    else
      render json: { error: 'unauthorized' }, status: 401
    end
  end

  private

  def login_params
    params.permit[:email, :password]
  end
end
