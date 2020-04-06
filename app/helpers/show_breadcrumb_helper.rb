# frozen_string_literal: true
module ShowBreadcrumbHelper
  def render_page_breadcrumbs(d)
    if parent_collection(d)
      render 'catalog/breadcrumbs', crumb_hashes: parent_coll_arr(d)
    elsif no_parent_work_w_collection(d)
      render 'catalog/breadcrumbs', crumb_hashes: no_par_work_w_coll_arr(d)
    elsif parent_work_w_collection(d)
      render 'catalog/breadcrumbs', crumb_hashes: par_work_w_coll_arr(d)
    elsif parent_work_no_collection(d)
      render 'catalog/breadcrumbs', crumb_hashes: par_work_w_no_coll(d)
    else
      render 'catalog/breadcrumbs', crumb_hashes: [item_breadcrumb(d)]
    end
  end

  # processed variables
  def b_t_a(d)
    title = d['title_tesim']&.first&.split(' ')
    title.first(3).join(' ') + '...' if title.size > 3
  end

  def standard_link(d)
    "/catalog/#{d['id']}"
  end

  def collection_link(d)
    "/catalog/#{d['member_of_collection_ids_ssim']&.first}"
  end

  def parent_work_link(d)
    "/catalog/#{d['parent_work_for_lux_tesim']&.first&.split(', ')&.first}"
  end

  # link hashes
  def item_breadcrumb(d)
    { curr_page: true, abbr: b_t_a(d), link: standard_link(d), title: standard_title(d) }
  end

  def back_collection_breadcrumb(d)
    { curr_page: false, abbr: nil, link: collection_link(d), title: b_t_c }
  end

  def back_parent_breadcrumb(d)
    { curr_page: false, abbr: nil, link: parent_work_link(d), title: b_t_p_o }
  end

  def back_parent_collection(d)
    { curr_page: false, abbr: nil, link: collection_link(d), title: b_t_p_o }
  end

  # arrays of hashes
  def parent_coll_arr(d)
    [back_parent_collection(d), item_breadcrumb(d)]
  end

  def no_par_work_w_coll_arr(d)
    [back_collection_breadcrumb(d), item_breadcrumb(d)]
  end

  def par_work_w_coll_arr(d)
    [back_collection_breadcrumb(d), back_parent_breadcrumb(d), item_breadcrumb(d)]
  end

  def par_work_w_no_coll(d)
    [back_parent_breadcrumb(d), item_breadcrumb(d)]
  end

  # unprocessed variables
  def standard_title(d)
    d['title_tesim']&.first
  end

  def b_t_p_o
    'Back to Parent Object'
  end

  def b_t_c
    'Back to Collection'
  end

  # tests
  def its_a_collection(d)
    d['has_model_ssim']&.first == 'Collection'
  end

  def not_related_collection(d)
    d['member_of_collection_ids_ssim'].nil?
  end

  def related_collection(d)
    d['member_of_collection_ids_ssim'].present?
  end

  def its_a_work(d)
    d['has_model_ssim']&.first == 'CurateGenericWork'
  end

  def no_parent(d)
    d['parent_work_for_lux_tesim'].nil?
  end

  def parent?(d)
    d['parent_work_for_lux_tesim'].present?
  end

  # test groups
  def no_parent_collection(d)
    its_a_collection(d) && not_related_collection(d)
  end

  def parent_collection(d)
    its_a_collection(d) && related_collection(d)
  end

  def no_parent_work_w_collection(d)
    its_a_work(d) && no_parent(d) && related_collection(d)
  end

  def parent_work_w_collection(d)
    its_a_work(d) && parent?(d) && related_collection(d)
  end

  def no_parent_or_collection_work(d)
    its_a_work(d) && no_parent(d) && not_related_collection(d)
  end

  def parent_work_no_collection(d)
    its_a_work(d) && parent?(d) && not_related_collection(d)
  end
end
