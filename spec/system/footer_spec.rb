# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'footer', type: :system, js: true do
  it 'has links to additional Lux pages' do
    visit "/"
    expect(page).to have_link("About Digital Collections", href: root_path)
    expect(page).to have_link("Copyright and Reuse", href: root_path)
    expect(page).to have_link("Contact", href: root_path)
    expect(page).to have_link("Donate", href: root_path)
  end

  it 'has links to other library sites' do
    visit "/"
    select "Business", from: "Locations (Footer)"
    expect(current_url).to eq("https://business.library.emory.edu/")

    visit "/"
    select "Cox Hall Computing Center", from: "Locations (Footer)"
    expect(current_url).to eq("http://it.emory.edu/studentdigitallife/study_production_spaces/computing-center-at-cox-hall/")

    visit "/"
    select "Health Sciences", from: "Locations (Footer)"
    expect(current_url).to eq("https://health.library.emory.edu/")

    visit "/"
    select "Law", from: "Locations (Footer)"
    expect(current_url).to eq("http://library.law.emory.edu/")

    visit "/"
    select "Library Service Center", from: "Locations (Footer)"
    expect(current_url).to eq("http://libraryservicecenter.org/")

    visit "/"
    select "Music & Media", from: "Locations (Footer)"
    expect(current_url).to eq("https://libraries.emory.edu/music-media/index.html")

    visit "/"
    select "Oxford College", from: "Locations (Footer)"
    expect(current_url).to eq("https://oxford.library.emory.edu/")

    visit "/"
    select "Rose", from: "Locations (Footer)"
    expect(current_url).to eq("https://rose.library.emory.edu/")

    visit "/"
    select "Science Commons", from: "Locations (Footer)"
    expect(current_url).to eq("https://libraries.emory.edu/science-commons/index.html")

    visit "/"
    select "Theology", from: "Locations (Footer)"
    expect(current_url).to eq("http://pitts.emory.edu/")

    visit "/"
    select "Woodruff", from: "Locations (Footer)"
    expect(current_url).to eq("https://libraries.emory.edu/woodruff/index.html")
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
