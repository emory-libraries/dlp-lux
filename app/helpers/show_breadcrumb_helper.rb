# frozen_string_literal: true
module ShowBreadcrumbHelper
  def render_page_breadcrumbs(d)
    if d.parent_collection
      render 'catalog/breadcrumbs', crumb_hashes: d.parent_coll_arr
    elsif d.no_parent_work_w_collection
      render 'catalog/breadcrumbs', crumb_hashes: d.no_par_work_w_coll_arr
    elsif d.parent_work_w_collection
      render 'catalog/breadcrumbs', crumb_hashes: d.par_work_w_coll_arr
    elsif d.parent_work_no_collection
      render 'catalog/breadcrumbs', crumb_hashes: d.par_work_w_no_coll
    else
      render 'catalog/breadcrumbs', crumb_hashes: [d.item_breadcrumb]
    end
  end
end
