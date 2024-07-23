# frozen_string_literal: true

RSpec.shared_examples('tests for expected component labels and values') do |wrapping_element_css = '.row dt'|
  it 'has the expected labels' do
    with_controller_class CatalogController do
      expect(render.css(wrapping_element_css).size).to eq(section_config.size)
      section_config.values.each do |value|
        expect(render.css(wrapping_element_css).text).to include(value)
      end
    end
  end

  it 'has the right label/value per row' do
    with_controller_class CatalogController do
      section_config.each do |solr_field, label|
        expect(render.css("dt.blacklight-#{solr_field.parameterize}").text).to include(label)
        if doc[solr_field].is_a?(Array)
          doc[solr_field].each do |value|
            if solr_field == 'finding_aid_link_ssm'
              expect(render.css("dd.blacklight-#{solr_field.parameterize}").text).to include('Finding Aid')
            else
              expect(render.css("dd.blacklight-#{solr_field.parameterize}").text).to include(value)
            end
          end
        else
          expect(render.css("dd.blacklight-#{solr_field.parameterize}").text).to include(doc[solr_field])
        end
      end
    end
  end
end

RSpec.shared_examples('tests for expected component link values') do |wrapping_element_css = '.row dd a'|
  it 'has the expected amount of links versus normal text' do
    with_controller_class CatalogController do
      expect(render.css(wrapping_element_css).size).to eq(pulled_linked_element_classes.size)
      expect(pulled_linked_element_classes).to match_array(expected_linked_element_classes)
    end
  end
end

RSpec.shared_examples('tests for object link') do |text, href|
  it("contains link for #{text}") { expect(render).to have_link(text, href:) }
end

RSpec.shared_examples('test for object images') do |path, text|
  it "contains the expected image for #{text}" do
    expect(render.css("img[src='#{path}']").attribute('alt').value).to eq(text)
  end
end
