# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  describe 'strong params' do
    it do
      params = {
        email: 'John', password: '0oK9Ij*uh'
      }
      should permit(:email, :password).for(:login, verb: :post, params:)
    end
  end

  describe 'callbacks' do
    it { should_not use_before_action(:authenticate_user) }
  end
end

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  let(:user) { create(:user) }
  context 'valid email and password' do
    let(:valid_creds) { { email: user.email, password: user.password } }
    before { post :login, params: valid_creds }
    it { should respond_with(:ok) }
    it 'should contain token' do
      expect { response.token.not_to be_nil }
    end
  end

  context 'invalid email' do
    let(:invalid_creds) { { email: '123@mail.com', password: '0oK9Ij*uh' } }
    before { post :login, params: invalid_creds }
    it { should respond_with(:unauthorized) }
  end

  context 'invalid password' do
    let(:invalid_creds) { { email: 'test@example.com', password: 'invalidpassword' } }
    before { post :login, params: invalid_creds }
    it { should respond_with(:unauthorized) }
  end
end
