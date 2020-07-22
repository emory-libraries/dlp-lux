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

  before { visit '/' }

  it 'has links to additional Lux pages' do
    expect(page).to have_link("About Digital Collections", href: about_path)
    expect(page).to have_link(
      "Copyright & Content",
      href: 'https://libraries.emory.edu/about/policies/digital-collections-copyright-and-content-policy.html'
    )
    expect(page).to have_link("Contact & Feedback", href: contact_path)
    expect(page).to have_link(
      "Donate",
      href: 'https://libraries.emory.edu/about/support-emory-libraries/index.html'
    )
  end

  it 'has links to other library sites' do
    options.each do |option|
      visit root_path
      select option[:name], from: "Locations (Footer)"
    end
  end

  it 'has version information' do
    expect(page).to have_css(".footer-version")
    expect(page).to have_content BRANCH
  end

  it 'has copyright information' do
    [
      ".footer-copyright", ".copyright-notice", ".copyright-signature", ".copyright-year", ".copyright-owner",
      ".copyright-rights", ".copyright-policies", ".copyright-address", ".copyright-phone"
    ].each do |c|
      expect(page).to have_css(c)
    end
    expect(page).to have_link("Privacy Policy", href: "https://libraries.emory.edu/about/policies/privacy-policy.html")
    expect(page).to have_link("Copyright Statement", href: "http://www.emory.edu/home/about-this-site/copyright.html")
  end

  context 'logo' do
    it 'has the right alt text' do
      ['a.footer-branding-logo', 'path.st0', 'g#badge-bg', 'g#badge'].each do |c|
        expect(page.find(c).text).to match(/Emory Libraries/)
      end
    end
  end
end
