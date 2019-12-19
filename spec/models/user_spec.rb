# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User do
  let(:user_with_uid) { described_class.new(uid: 'user123') }
  context 'omniauthable user' do
    it "has a uid field" do
      expect(user_with_uid.uid).not_to be_empty
    end
    it "can have a provider" do
      expect(user_with_uid.respond_to?(:provider)).to eq true
    end
  end

  context "shibboleth integration" do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        provider: 'shibboleth',
        uid: "janeq",
        info: {
          display_name: "Jane Quest",
          uid: 'janeq',
          mail: 'janeq@emory.edu'
        }
      )
    end
    let(:user) { described_class.from_omniauth(auth_hash) }

    before do
      described_class.delete_all
    end

    context "shibboleth" do
      it "has a shibboleth provided name" do
        expect(user.display_name).to eq auth_hash.info.display_name
      end
      it "has a shibboleth provided uid which is not nil" do
        expect(user.uid).to eq auth_hash.info.uid
        expect(user.uid).not_to eq nil
      end
      it "has a shibboleth provided email which is not nil" do
        expect(user.email).to eq auth_hash.info.mail
        expect(user.email).not_to eq nil
      end
    end
  end
end
