# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'footer', type: :system, js: true do
  let(:options) do
    [
      {
        name: "Business",
        url: "https://business.library.emory.edu/"
      },
      {
        name: "Cox Hall Computing Center",
        url: "http://it.emory.edu/studentdigitallife/study_production_spaces/computing-center-at-cox-hall/"
      },
      {
        name: "Health Sciences",
        url: "https://health.library.emory.edu/"
      },
      {
        name: "Law",
        url: "http://library.law.emory.edu/"
      },
      {
        name: "Library Service Center",
        url: "http://libraryservicecenter.org/"
      },
      {
        name: "Music & Media",
        url: "https://libraries.emory.edu/music-media/index.html"
      },
      {
        name: "Oxford College",
        url: "https://oxford.library.emory.edu/"
      },
      {
        name: "Rose",
        url: "https://rose.library.emory.edu/"
      },
      {
        name: "Science Commons",
        url: "https://libraries.emory.edu/science-commons/index.html"
      },
      {
        name: "Theology",
        url: "http://pitts.emory.edu/"
      },
      {
        name: "Woodruff",
        url: "https://libraries.emory.edu/woodruff/index.html"
      }
    ]
  end

  it 'has links to additional Lux pages' do
    visit "/"
    expect(page).to have_link("About Digital Collections", href: root_path)
    expect(page).to have_link("Copyright and Reuse", href: root_path)
    expect(page).to have_link("Contact", href: contact_path)
    expect(page).to have_link("Donate", href: root_path)
  end

  it 'has links to other library sites' do
    options.each do |option|
      visit root_path
      select option[:name], from: "Locations (Footer)"
    end
  end

  it 'has version information' do
    visit "/"
    expect(page).to have_css(".footer-version")
    expect(page).to have_content BRANCH
  end

  it 'has copyright information' do
    visit "/"
    expect(page).to have_css(".footer-copyright")
    expect(page).to have_css(".copyright-notice")
    expect(page).to have_css(".copyright-signature")
    expect(page).to have_css(".copyright-year")
    expect(page).to have_css(".copyright-owner")
    expect(page).to have_css(".copyright-rights")
    expect(page).to have_css(".copyright-policies")
    expect(page).to have_link("Privacy Policy", href: "https://libraries.emory.edu/about/policies/privacy-policy.html")
    expect(page).to have_link("Copyright Statement", href: "http://www.emory.edu/home/about-this-site/copyright.html")
    expect(page).to have_css(".copyright-address")
    expect(page).to have_css(".copyright-phone")
  end
end
