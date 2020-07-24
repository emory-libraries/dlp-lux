# frozen_string_literal: true

RSpec.shared_examples 'searches_the_right_field_for' do |f_title, field, title_array|
  let(:search_term) { 'iMCnR6E8' }

  def resulting_titles
    page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
  end

  it "searches the right fields for #{f_title} target" do
    fill_in field, with: search_term
    click_on 'advanced-search-submit'

    within '#documents' do
      expect(resulting_titles).to match(title_array)
    end
  end
end
