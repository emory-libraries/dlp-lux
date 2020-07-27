# frozen_string_literal: true
module BlacklightAdvancedSearchHelper
  # Replaces select_menu_for_field_operator helper from
  # projectblacklight/blacklight_advanced_search v7.0.0 so that
  # we can add in accessibility improvements
  def emory_select_menu_for_field_operator
    options = {
      t('blacklight_advanced_search.all') => 'AND',
      t('blacklight_advanced_search.any') => 'OR'
    }.sort

    select_tag(:op, options_for_select(options, params[:op]), class: 'input-small', title: "find items that match")
  end
end
