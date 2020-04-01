# frozen_string_literal: true

RSpec.shared_examples "check_page_for_link" do |link, route|
  it "has link: #{link}" do
    expect(page).to have_css("a.breadcrumb-link", text: link)
    expect(page).to have_xpath("//a[@href='#{route}' and @class='breadcrumb-link']")
  end
end

RSpec.shared_examples "check_page_for_current_link" do |link, route|
  it "has link for current page: #{link}" do
    expect(page).to have_css("a.breadcrumb-link.current-page", text: link)
    expect(page).to have_xpath("//a[@href='#{route}' and @class='breadcrumb-link current-page']")
  end
end

RSpec.shared_examples "check_page_for_full_link" do |link|
  it 'shows full title when hovered on' do
    page.execute_script('$(".current-page").trigger("mouseover")')

    expect(page).to have_css("a.breadcrumb-link", text: link)
  end
end

RSpec.shared_examples "check_page_for_link_static" do |link, route|
  it "has link: #{link}" do
    visit route

    expect(page).to have_css("a.breadcrumb-link", text: link)
    expect(page).to have_xpath("//a[@href='/' and @class='breadcrumb-link']")
  end
end

RSpec.shared_examples "check_page_for_current_link_static" do |link, route|
  it "has link for current page: #{link}" do
    visit route

    expect(page).to have_css("a.breadcrumb-link.current-page", text: link)
    expect(page).to have_xpath("//a[@href='#{route}' and @class='breadcrumb-link current-page']")
  end
end

RSpec.shared_examples "check_page_for_full_link_static" do |link, route|
  it 'shows full title when hovered on' do
    visit route
    page.execute_script('$(".current-page").trigger("mouseover")')

    expect(page).to have_css("a.breadcrumb-link", text: link)
  end
end
