# frozen_string_literal: true
require 'rails_helper'

RSpec.feature "View a Work" do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
    allow(Rails.application.config).to receive(:iiif_url).and_return('https://example.com')
    visit solr_document_path(id)
  end

  let(:id) { '123' }

  let(:work_attributes) do
    CURATE_GENERIC_WORK
  end

  it 'has the uv html on the page' do
    expect(page.html).to match(/universal-viewer-iframe/)
  end

  it 'has partials' do
    expect(page).to have_css('.is-part-of')
    expect(page).to have_content('This item is part of:')
    expect(page).to have_css('.about-this-item')
    expect(page).to have_content('About This Item')
    expect(page).to have_css('.subjects-keywords')
    expect(page).to have_content('Subjects / Keywords')
    expect(page).to have_css('.find-this-item')
    expect(page).to have_content('Find This Item')
    expect(page).to have_css('.publication-details')
    expect(page).to have_content('Publication Details')
    expect(page).to have_css('.related-material')
    expect(page).to have_content('Related Material')
    expect(page).to have_css('.misc-details')
    expect(page).to have_content('Misc Details')
    expect(page).to have_css('.access-and-copyright')
    expect(page).to have_content('Access and Copyright')
  end

  it 'has title, creator, date created, and content type on the page' do
    expect(page).to have_content('The Title of my Work')
    expect(page).to have_content('This is a uniform title')
    expect(page).to have_content('This is a series title')
    expect(page).to have_content('This is a parent title')
    expect(page).to have_content('Smith, Somebody')
    expect(page).to have_content('Contributor, Jack')
    expect(page).to have_content('1776')
    expect(page).to have_content('XXXX')
    expect(page).to have_content('192?')
    expect(page).to have_content('1973?')
    expect(page).to have_content('1652')
    expect(page).to have_content('1985')
    expect(page).to have_content('Text')
    expect(page).to have_content('Painting')
    expect(page).to have_content('152 p., [50] leaves of plates')
    expect(page).to have_content('English')
    expect(page).to have_content('notes about a thing')
    expect(page).to have_content('Description or abstract of work')
    expect(page).to have_content('Table of contents, Here\'s another content')
    expect(page).to have_content('A topic for a subject')
    expect(page).to have_content('Qāsimlū, Mujtabá')
    expect(page).to have_content('New Jersey')
    expect(page).to have_content('Edo (African)')
    expect(page).to have_content('key')
    expect(page).to have_content('words')
    expect(page).to have_content('System of record ID seems to be a user entered string')
    expect(page).to have_content('This is a legacy Emory ARK ID')
    expect(page).to have_content('oclc:(OCoLC)772049332')
    expect(page).to have_content('barcode:050000087509')
    expect(page).to have_content('Emory University')
    expect(page).to have_content('Oxford College Library')
    expect(page).to have_content('Stuart A. Rose Manuscript, Archives, and Rare Book Library')
    expect(page).to have_content('That weird cart in the third basement')
    expect(page).to have_content('ML450.B613 v. 3')
    expect(page).to have_content('Call Milly')
    expect(page).to have_content('New York Labor News Company')
    expect(page).to have_content('https://final_version.com')
    expect(page).to have_content('https://publisher_version.com')
    expect(page).to have_content('Carrboro, NC')
    expect(page).to have_content('1')
    expect(page).to have_content('3rd ed.')
    expect(page).to have_content('224')
    expect(page).to have_content('iii')
    expect(page).to have_content('501')
    expect(page).to have_content('0044-8399')
    expect(page).to have_content('9780415364256')
    expect(page).to have_content('June 3-5, 1987')
    expect(page).to have_content('Pearl Hacks')
    expect(page).to have_content('Company, Inc.')
    expect(page).to have_content('Genetics Laboratory')
    expect(page).to have_content('National Endowment for the Arts')
    expect(page).to have_content('Can\'t use anything offensive.')
    expect(page).to have_content('This is the best data ever.')
    expect(page).to have_content('From Kari\'s hard drive.')
    expect(page).to have_content('State')
    expect(page).to have_content('This is a note about technical details')
    expect(page).to have_content('Other related materials and other things.')
    expect(page).to have_content('Sister Outsider')
    expect(page).to have_content('Other datasets that are somehow relevant.')
    expect(page).to have_content('Srsly, y\'all, don\'t copy this.')
    expect(page).to have_content('In Copyright - EU Orphan Work')
    expect(page).to have_content('Owned by Jamie')
    expect(page).to have_content('2027')
    expect(page).to have_content('Creative Commons BY Attribution 4.0 International')
    expect(page).to have_content('You can access this only in the Rose reading room, alternate Thursdays.')
    expect(page).to have_content('Chester W. Topp collection of Victorian yellowbacks and paperbacks')
  end
end
