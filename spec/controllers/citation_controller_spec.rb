# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Blacklight::Citeproc::CitationController, type: :controller do
  before do
    config = CatalogController.blacklight_config.citeproc
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
    controller.instance_variable_set(:@config, config)
  end

  let(:id) { '123' }
  let(:work_attributes) { CURATE_GENERIC_WORK }

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
end
