# == Schema Information
#
# Table name: communities
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Community < ApplicationRecord
  has_many :posts
  validates :name, presence: true, uniqueness: true, length: { within: 3..25 }
  validates :description, presence: true
end
