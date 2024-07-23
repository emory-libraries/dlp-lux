# frozen_string_literal: true

RSpec.shared_examples "check_page_for_link" do |link, route, capy_obj|
  it "has link: #{link}" do
    subj = capy_obj == 'page' ? page : render

    expect(subj).to have_xpath("//a[@href='#{route}' and @id='crumb' and text()='#{link}']")
  end
end

RSpec.shared_examples "check_page_for_current_link" do |link, route, capy_obj|
  it "has link for current page: #{link}" do
    subj = capy_obj == 'page' ? page : render

    expect(subj).to have_xpath(
      "//a[@href='#{route}' and @id='crumb' and text()='#{link}']"
    )
  end
end

RSpec.shared_examples "check_page_for_full_link" do |link|
  it 'shows full title when hovered on' do
    page.execute_script('$("a#crumb.current-page").trigger("mouseover")')

    expect(page).to have_css("a#crumb", text: link)
  end
end

RSpec.shared_examples "check_page_for_link_static" do |link, route|
  it "has link: #{link}" do
    visit route

    expect(page).to have_xpath("//a[@href='/' and @id='crumb' and text()='#{link}']")
  end
end

RSpec.shared_examples "check_page_for_current_link_static" do |link, route|
  it "has link for current page: #{link}" do
    visit route

    expect(page).to have_xpath("//a[@href='#{route}' and @id='crumb' and text()='#{link}']")
  end
end

RSpec.shared_examples "check_page_for_full_link_static" do |link, route|
  it 'shows full title when hovered on' do
    visit route

    page.execute_script('$("a#crumb.current-page").trigger("mouseover")')

    expect(page).to have_css("a#crumb", text: link)
  end
end
