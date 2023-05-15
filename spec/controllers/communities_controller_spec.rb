# frozen_string_literal: true

require 'rails_helper'
# require 'jwt'

RSpec.describe Api::V1::CommunitiesController, type: :controller do
  context 'callbacks' do
    it { should use_before_action(:authorize_admin) }
    it { should use_before_action(:set_community) }
    it { should use_before_action(:authenticate_user) }
  end
end
