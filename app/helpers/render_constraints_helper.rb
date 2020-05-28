# frozen_string_literal: true
module RenderConstraintsHelper
  include BlacklightAdvancedSearch::RenderConstraintsOverride

  # query_has_constraints? overridden from RenderConstraintsOverride to include :range
  def query_has_constraints?(localized_params = params)
    if is_advanced_search? localized_params
      true
    else
      !(localized_params[:q].blank? && localized_params[:f].blank? && localized_params[:range].blank? && localized_params[:f_inclusive].blank?)
    end
  end

  def missing_constraint_url(field_name)
    search_action_url(add_range_missing(field_name))
  end

  def missing_constraint_url_corrected(field_name)
    missing_url = missing_constraint_url(field_name)
    if missing_url.include?("&search_field=common_fields")
      missing_url
    else
      "#{missing_url}&search_field=common_fields"
    end
  end
end
