# frozen_string_literal: true
# Blacklight::System::ModalComponent v7.33.1 Override - use our structure instead
require 'rails_helper'

RSpec.describe Lux::Citation::ModalComponent, type: :component do
  subject(:render) { render_inline(described_class.new) }

  it 'includes our desired warning text' do
    expect(render.css('div.modal-header.citations').text).to include(
      'Provided as a suggestion only. Please verify these automated citations against the guidelines of your preferred style.'
    )
  end
end
