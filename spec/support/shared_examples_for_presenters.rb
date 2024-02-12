# frozen_string_literal: true

RSpec.shared_examples('tests for expected terms') do
  it 'has the correct terms' do
    expect(pres_terms).to be_a Enumerator
    expect(pres_terms.to_a.map(&:first)).to match_array(expected_terms.keys)
    expect(pres_terms.to_a.map { |t| t[2].values }).to match_array(expected_terms.values)
  end
end
