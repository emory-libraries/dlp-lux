# frozen_string_literal: true
module ShowBreadcrumbHelper
  def render_page_breadcrumbs(d)
    if d.parent_collection
      render 'catalog/breadcrumbs', crumb_hashes: parent_coll_arr(d)
    elsif d.no_parent_work_w_collection
      render 'catalog/breadcrumbs', crumb_hashes: no_par_work_w_coll_arr(d)
    elsif d.parent_work_w_collection
      render 'catalog/breadcrumbs', crumb_hashes: par_work_w_coll_arr(d)
    elsif d.parent_work_no_collection
      render 'catalog/breadcrumbs', crumb_hashes: par_work_w_no_coll(d)
    else
      render 'catalog/breadcrumbs', crumb_hashes: [d.item_breadcrumb]
    end
  end

  # breadcrumb hash arrays
  def parent_coll_arr(d)
    [d.back_parent_coll_breadcrumb, d.item_breadcrumb]
  end

  def no_par_work_w_coll_arr(d)
    [d.back_collection_breadcrumb, d.item_breadcrumb]
  end

  def par_work_w_coll_arr(d)
    [d.back_collection_breadcrumb, d.back_parent_breadcrumb, d.item_breadcrumb]
  end

  def par_work_w_no_coll(d)
    [d.back_parent_breadcrumb, d.item_breadcrumb]
  end
end
