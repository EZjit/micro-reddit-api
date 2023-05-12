# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string
#  username        :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_admin        :boolean          default(FALSE)
#
class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :name, :recently_joined?

  def recently_joined?
    Date.today.prev_month < object.created_at
  end
end
