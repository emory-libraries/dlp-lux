# frozen_string_literal: true

RSpec.shared_context('setup common component variables') do |with_presenter = true|
  subject(:render) do
    with_request_url "/catalog/#{doc.id}" do
      render_inline(instance)
    end
  end
  let(:instance) { described_class.new(document: doc) }
  let(:doc_presenter) { Blacklight::ShowPresenter.new(doc, controller.view_context) } if with_presenter
  let(:response) { instance_double(Blacklight::Solr::Response) }

  before do
    if with_presenter
      allow(instance).to receive(:document_presenter).and_return(doc_presenter)
      allow(instance).to receive(:fields).and_return(fields)
    end
    allow(doc).to receive(:response).and_return(response)
    allow(response).to receive(:[]).with('highlighting').and_return(nil)
  end
end
