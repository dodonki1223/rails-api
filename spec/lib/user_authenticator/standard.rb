require 'rails_helper'

describe UserAuthenticator::Standard do
  describe '#perform' do
    let(:authenticator) { described_class.new('dodonki1223', 'password') }
    subject { authenticator.perform }

    before { user }

    shared_examples_for 'invalid authentication' do
      it 'should raise an error' do
        expect{ subject }.to raise_errors(UserAuthenticator::Standard::AuthenticationError)
        expect(authenticator.user).to be_nil
      end
    end

    context 'when invalid login' do
      let(:user) { create :user, login: 'dodonki1223', password: 'secret' }
      it_behaves_like 'invalid authentication'
    end

    context 'when invalid password' do
      it_behaves_like 'invalid authentication'
    end

    context 'when successed auth' do
      
    end
  end
end
