# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :name, :recently_joined?

  def recently_joined?
    Date.today.prev_month < object.created_at
  end
end
