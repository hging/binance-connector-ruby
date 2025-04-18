# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Binance::Spot::Convert, '#sub_account_enable_options' do
  let(:path) { '/sapi/v1/sub-account/eoptions/enable' }
  let(:body) { fixture('response.json') }
  let(:status) { 200 }

  before do
    mocking_signature_and_ts(**params)
    stub_binance_sign_request(:post, path, status, body, params)
  end

  context 'validation' do
    where(:params) do
      [
        { email: '' }
      ]
    end
    with_them do
      it 'should raise validation error without mandatory params' do
        expect { spot_client_signed.sub_account_enable_options(**params) }.to raise_error(Binance::RequiredParameterError)
      end
    end
  end

  context 'with params' do
    let(:params) { { email: 'test@test.com' } }
    it 'should enable options for Sub-account' do
      spot_client_signed.sub_account_enable_options(**params)
      expect(send_a_request_with_signature(:post, path, params)).to have_been_made
    end
  end
end
