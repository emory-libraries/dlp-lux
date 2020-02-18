# frozen_string_literal: true
module ApplicationHelper
  def display_num_members(document)
    pluralize(document["member_works_count_isi"], "Item")
  end

  def display_num_children(document)
    pluralize(document["child_works_for_lux_tesim"].count, "Item")
  end

  def link_to_parent_work(document)
    parts = document["parent_work_for_lux_tesim"].first.split(", ")
    path = "/catalog/" + parts[0]
    title = parts[1]
    link_to title, path
  end
end
