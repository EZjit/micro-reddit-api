# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string
#  username        :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :name, :recently_joined?

  def recently_joined?
    Date.today.prev_month < object.created_at
  end
end
