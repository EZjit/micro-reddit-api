# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonWebToken
  include Pagy::Backend

  before_action :authenticate_user
  after_action { pagy_headers_merge(@pagy) if @pagy }

  private

  def authenticate_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = jwt_decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: 401
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: 401
    end
  end

  def authorize_admin
    render json: { message: 'Admin only, not authorized!' }, status: 401 unless authenticate_user.admin?
  end

  def author?(object)
    render json: { message: 'Author only, not authorized!' }, status: 401 unless authenticate_user == object.user
  end
end
