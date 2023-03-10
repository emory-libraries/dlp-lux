# frozen_string_literal: true
require 'rails_helper'
require_relative '../../../db/concerns/default_explore_collections'
include DefaultExploreCollections

RSpec.describe Admin::ExploreCollectionsController, type: :controller do
  before { stub_default_explore_collections }
  let(:user) { User.create(uid: 'test') }
  let(:explore_collection) { ExploreCollection.first }

  describe '#index' do
    context 'when a user is logged in' do
      before do
        sign_in(user)
      end

      context 'and is an admin' do
        it 'loads explore collection dashboard' do
          allow_any_instance_of(Ability).to receive(:admin?).and_return(true)
          get :index
          expect(response).to have_http_status(:success)
        end
      end

      context 'and is a guest' do
        it 'denies access to the explore collection dashboard' do
          expect { get :index }.to raise_error CanCan::AccessDenied
        end
      end
    end

    context 'when no user is logged in' do
      it 'denies access to the explore collection dashboard' do
        expect { get :index }.to raise_error CanCan::AccessDenied
      end
    end
  end

  describe '#show' do
    context 'when a user is logged in' do
      before do
        sign_in(user)
      end

      context 'and is an admin' do
        it 'loads the explore collection' do
          allow_any_instance_of(Ability).to receive(:admin?).and_return(true)
          get :show, params: { id: explore_collection.id.to_s }
          expect(response).to have_http_status(:success)
        end
      end

      context 'and is a guest' do
        it 'denies access to the explore collection' do
          expect { get :show, params: { id: explore_collection.id.to_s } }.to raise_error CanCan::AccessDenied
        end
      end
    end

    context 'when no user is logged in' do
      it 'denies access to the explore collection' do
        expect { get :show, params: { id: explore_collection.id.to_s } }.to raise_error CanCan::AccessDenied
      end
    end
  end

  describe '#update' do
    context 'when a user is logged in' do
      before do
        sign_in(user)
      end

      context 'and is an admin' do
        it 'enables user to update the explore collection' do
          allow_any_instance_of(Ability).to receive(:admin?).and_return(true)
          put :update, params: { "explore_collection" => { "title" => "new_title" }, "id" => explore_collection.id.to_s }
          expect(response).to have_http_status(:found)
          explore_collection.reload
          expect(explore_collection.title).to eq('new_title')
        end
      end

      context 'and is a guest' do
        it 'denies access to the explore collection' do
          expect { put :update, params: { "explore_collection" => { "title" => "hello_world" }, "id" => explore_collection.id.to_s } }.to raise_error CanCan::AccessDenied
        end
      end
    end

    context 'when no user is logged in' do
      it 'denies access to the explore collection' do
        expect { put :update, params: { "explore_collection" => { "title" => "hello_world" }, "id" => explore_collection.id.to_s } }.to raise_error CanCan::AccessDenied
      end
    end
  end

  describe '#destroy' do
    context 'when a user is logged in' do
      before do
        sign_in(user)
      end

      context 'and is an admin' do
        it 'is not permitted' do
          expect { delete :destroy, params: { id: explore_collection.id } }.to raise_error CanCan::AccessDenied
        end
      end

      context 'and is a guest' do
        it 'is not permitted' do
          expect { delete :destroy, params: { id: explore_collection.id } }.to raise_error CanCan::AccessDenied
        end
      end
    end

    context 'when no user is logged in' do
      it 'is not permitted' do
        expect { delete :destroy, params: { id: explore_collection.id } }.to raise_error CanCan::AccessDenied
      end
    end
  end
end
