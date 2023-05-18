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
    render json: { errors: 'Admin-only functionality' }, status: 401 unless authenticate_user.admin?
  end

  def author?(object)
    render json: { errors: 'You are not allowed to do this' }, status: 401 unless authenticate_user == object&.user
  end

  def not_found(object_class_name)
    render json: { errors: "#{object_class_name.capitalize} not found" }, status: 404
  end
end
