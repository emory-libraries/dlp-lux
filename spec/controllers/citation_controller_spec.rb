# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe Blacklight::Citeproc::CitationController, type: :controller do
  before do
    config = CatalogController.blacklight_config.citeproc
    solr = Blacklight.default_index.connection
    solr.add([work_attributes, work_attributes2])
    solr.commit
    controller.instance_variable_set(:@config, config)
    sign_in user
  end

  let(:id) { '123' }
  let(:id2) { '030prr4xkj-cor' }
  let(:work_attributes) { CURATE_GENERIC_WORK }
  let(:work_attributes2) { PARENT_CURATE_GENERIC_WORK }
  let(:user) { FactoryBot.create(:user) }

  describe '#print_single' do
    before { get :print_single, params: { id: id } }

    it 'renders the print single template' do
      expect(response.content_type).to eq "text/html"
      expect(response).to render_template(:print_single)
    end

    it 'populates @citations instance variable' do
      expect(assigns(:citations)).not_to be_empty
      expect(assigns(:citations).size).to eq(3)
    end

    it 'populates @citations with the right keys' do
      expect(assigns(:citations).first.keys).to eq([:citation, :label, :id])
    end

    it 'produces the expected citations' do
      expect(assigns(:citations).first[:citation]).to eq(
        "Smith, S. <i>The Title of my Work</i> (3rd ed.). New York Labor News Company. https://digital.library.emory.edu/purl/123"
      )
    end

    it 'does not return an empty value' do
      values = assigns(:citations).map(&:values).flatten.compact

      expect(values.size).to eq(9)
    end
  end

  describe '#print_bookmarks' do
    before do
      user.bookmarks.create(user_type: 'User', document_type: 'SolrDocument', document_id: id)
      user.bookmarks.create(user_type: 'User', document_type: 'SolrDocument', document_id: id2)
      get :print_bookmarks
    end

    it 'renders the print multiple template' do
      expect(response.content_type).to eq "text/html"
      expect(response).to render_template(:print_multiple)
    end

    it 'populates @citations instance variable' do
      expect(assigns(:citations)).not_to be_empty
      expect(assigns(:citations).size).to eq(6)
    end

    it 'populates @citations with the right keys' do
      expect(assigns(:citations).first.keys).to eq([:citation, :label, :id])
    end

    it 'produces the expected citations' do
      expect(assigns(:citations).first[:citation]).to eq(
        "Creator, S. P. (1919/192X). <i>Emocad.</i> Emory University. https://digital.library.emory.edu/purl/030prr4xkj-cor"
      )
      expect(assigns(:citations)[3][:citation]).to eq(
        "Smith, S. <i>The Title of my Work</i> (3rd ed.). New York Labor News Company. https://digital.library.emory.edu/purl/123"
      )
    end

    it 'does not return an empty value' do
      values = assigns(:citations).map(&:values).flatten.compact

      expect(values.size).to eq(18)
    end
  end
end
