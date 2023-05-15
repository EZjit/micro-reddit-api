# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JsonWebToken do
  context 'encode-decode' do
    let(:extended_class) { Class.new { extend JsonWebToken } }
    let(:payload) { { user_id: 123 } }
    let(:encoded_decoded) { extended_class.jwt_decode(extended_class.jwt_encode(payload)) }
    let(:exp_time) { encoded_decoded[:exp] }
    it 'double transform should return exact same user_id' do
      expect(encoded_decoded[:user_id]).to eq(payload[:user_id])
    end
    it 'should contain exp date' do
      expect(exp_time).not_to be_nil
    end
    it 'exp date should be less then current time + 24 hours' do
      expect(exp_time).to be_between(23.hours.from_now.to_i, 24.hours.from_now.to_i)
    end
  end
end
