# frozen_string_literal: true

require 'jwt'

module ControllerHelpers
  def get_auth_token(user)
    token = JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i },
                       Rails.application.secrets.secret_key_base.to_s)
    request.headers['Authorization'] = token
  end
end
