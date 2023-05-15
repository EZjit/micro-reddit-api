# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :string           not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#  parent_id  :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null

require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body) }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:post).inverse_of(:comments) }
    it { should belong_to(:parent).optional.inverse_of(:comments) }
    it { should belong_to(:parent).optional.class_name('Comment') }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:comments).inverse_of(:parent) }
    it { should have_many(:comments).with_foreign_key('parent_id') }
  end
end
