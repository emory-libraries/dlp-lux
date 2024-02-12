# frozen_string_literal: true
require 'rails_helper'

# NOTE: This is a copy of Blacklight v7.33.1's Blacklight::MetadataFieldComponent tests.
#   It is necessary to bring Components that are called within an overridden component
#   into an application using Blacklight because they expect the Components being called
#   to be within the same directory.
RSpec.describe Lux::MetadataFieldComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(field:))
  end

  let(:view_context) { controller.view_context }
  let(:document) { SolrDocument.new('field' => ['Value']) }
  let(:field_config) { Blacklight::Configuration::Field.new(key: 'field', field: 'field', label: 'Field label') }

  let(:field) do
    Blacklight::FieldPresenter.new(view_context, document, field_config)
  end

  it 'renders the field label' do
    expect(rendered).to have_selector 'dt.blacklight-field', text: 'Field label'
  end

  it 'renders the field value' do
    expect(rendered).to have_selector 'dd.blacklight-field', text: 'Value'
  end

  context 'from a show view' do
    subject(:rendered) do
      render_inline_to_capybara_node(described_class.new(field:, show: true))
    end

    it 'renders the right field label' do
      allow(field).to receive(:label).with('show').and_return('custom label')

      expect(rendered).to have_selector 'dt.blacklight-field', text: 'custom label'
    end
  end
end
