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
require "test_helper"

class CommunityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
