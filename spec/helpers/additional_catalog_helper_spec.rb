# frozen_string_literal: true
require 'rails_helper'
require './app/helpers/additional_catalog_helper'

RSpec.describe AdditionalCatalogHelper, type: :helper do
  let(:field_names) do
    [
      'human_readable_date_created_tesim',
      'human_readable_date_issued_tesim',
      'human_readable_data_collection_dates_tesim',
      'human_readable_conference_dates_tesim',
      'human_readable_copyright_date_tesim'
    ]
  end

  describe "#purl" do
    it "returns the correct url" do
      doc_id = "123"
      doc_id2 = "3418kprr6m-cor"

      expect(helper.purl(doc_id)).to eq("https://digital.library.emory.edu/purl/123")
      expect(helper.purl(doc_id2)).to eq("https://digital.library.emory.edu/purl/3418kprr6m-cor")
    end

    it "returns a url with no id when id nil" do
      doc_id = ""

      expect(helper.purl(doc_id)).to eq("https://digital.library.emory.edu/purl/")
    end
  end

  describe "#field_is_for_dates?" do
    it "returns true when field name matches" do
      field_names.each do |field_name|
        expect(helper.field_is_for_dates?(field_name)).to be_truthy
      end
    end

    it "returns false when wrong field name or nil" do
      expect(helper.field_is_for_dates?("say_what?")).to be_falsey
      expect(helper.field_is_for_dates?("")).to be_falsey
    end
  end

  describe "#dates_on_separate_lines" do
    let(:date_array) do
      [
        "October 22, 2018 to October 25, 2018",
        "January 1998 to May 2001",
        "190s0s",
        "within the 1930s or 1940s"
      ]
    end
    let(:merging_hash) do
      field_names.index_with { date_array }
    end
    let(:merging_hash2) do
      field_names.index_with { [date_array.first] }
    end
    let(:document) { CHILD_CURATE_GENERIC_WORK_3.dup.merge(merging_hash) }
    let(:document2) { CHILD_CURATE_GENERIC_WORK_3.dup.merge(merging_hash2) }

    it "joins <br> between each element of the array" do
      field_names.each do |field_name|
        expect(dates_on_separate_lines(document, field_name).scan(/(?<=\<br\>)/).count).to eq(3)
      end
    end

    it "inserts no <br> with only one element in the array" do
      field_names.each do |field_name|
        expect(dates_on_separate_lines(document2, field_name).scan(/(?<=\<br\>)/).count).to eq(0)
      end
    end
  end
end
