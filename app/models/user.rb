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
class User < ApplicationRecord
  PASSWORD_FORMAT = /\A
  (?=.{6,})          # Must contain 6 or more characters
  (?=.*\d)           # Must contain a digit
  (?=.*[a-z])        # Must contain a lower case character
  (?=.*[A-Z])        # Must contain an upper case character
  (?=.*[[:^alnum:]]) # Must contain a symbol
/x

  has_secure_password

  validates :username, presence: true, uniqueness: true, length: { within: 2..25 }
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            presence: true,
            length: { within: 6..20 },
            format: { with: PASSWORD_FORMAT },
            confirmation: true

  def admin?
    is_admin == true
  end
end
