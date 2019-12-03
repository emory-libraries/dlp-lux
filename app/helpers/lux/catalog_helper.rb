# frozen_string_literal: true
module Lux
  module CatalogHelper
    # @param [Hash] args from get_field_values
    def render_human_readable_date(args)
      date_created = args[:value]
      date_created.map{ |date_created| human_readable_date(date_created) }.join( ', ')
    end

    def human_readable_date(date_created)
      return 'unknown' if date_created == 'XXXX'
      return date_created.gsub('?','0s') if date_created.size == 4 && date_created.ends_with?('?')
      date_created
    end
  end
end
