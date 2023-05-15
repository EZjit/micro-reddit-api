# frozen_string_literal: true

# == Schema Information
#
# Table name: communities
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Community, type: :model do
  context 'validations' do
    describe 'name field' do
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name) }
      describe 'uniqueness constraint' do
        subject { build(:community) }
        it { should validate_uniqueness_of(:name) }
      end
    end
    describe 'description field' do
      it { should validate_presence_of(:name) }
    end
  end

  context 'associations' do
    it { should have_many(:posts).dependent(:destroy) }
  end
end
