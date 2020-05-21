# frozen_string_literal: true

RSpec.shared_examples "check_citation_item_key_and_values" do |method, key_arr, keys_values_hsh|
  it "has the right keys" do
    expect(cit_gen.send(method).keys).to eq(key_arr)
  end

  it 'has the right values' do
    cit_gen_chunk = cit_gen.send(method)

    expect(cit_gen_chunk).to eq(keys_values_hsh)
  end
end
