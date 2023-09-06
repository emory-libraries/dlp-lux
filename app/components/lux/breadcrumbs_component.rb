# frozen_string_literal: true

module Lux
  class BreadcrumbsComponent < Blacklight::Component
    attr_reader :crumb_hashes

    def initialize(document: nil, crumb_hashes: [])
      @document = document
      @crumb_hashes = @document.present? ? page_breadcrumbs_parser : crumb_hashes
    end

    def page_breadcrumbs_parser
      if @document.parent_collection
        parent_coll_arr
      elsif @document.no_parent_work_w_collection
        no_par_work_w_coll_arr
      elsif @document.parent_work_w_collection
        par_work_w_coll_arr
      elsif @document.parent_work_no_collection
        par_work_w_no_coll
      else
        [@document.item_breadcrumb]
      end
    end

    # breadcrumb hash arrays
    def parent_coll_arr
      [@document.back_parent_coll_breadcrumb, @document.item_breadcrumb]
    end

    def no_par_work_w_coll_arr
      [@document.back_collection_breadcrumb, @document.item_breadcrumb]
    end

    def par_work_w_coll_arr
      [@document.back_collection_breadcrumb, @document.back_parent_breadcrumb, @document.item_breadcrumb]
    end

    def par_work_w_no_coll
      [@document.back_parent_breadcrumb, @document.item_breadcrumb]
    end
  end
end
