# frozen_string_literal: true
class CatalogController < ApplicationController
  include BlacklightRangeLimit::ControllerOverride
  include BlacklightAdvancedSearch::Controller
  include Blacklight::Catalog
  include Blacklight::AccessControls::Catalog

  rescue_from NameError, with: :render_404

  def render_404
    render file: Rails.root.join('app', 'views', 'static', 'not_found.html.erb'), status: :not_found, layout: true
  end

  # Apply the blacklight-access_controls
  before_action :enforce_show_permissions, only: :show

  include Blacklight::Marc::Catalog

  def guest_uid_authentication_key(key)
    guest_email_authentication_key(key)
  end

  configure_blacklight do |config|
    # default advanced config values
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    # config.advanced_search[:qt] ||= 'advanced'
    config.advanced_search[:url_key] ||= 'advanced'
    config.advanced_search[:query_parser] ||= 'dismax'
    config.advanced_search[:form_solr_parameters] ||= {}

    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response
    #
    ## Should the raw solr document endpoint (e.g. /catalog/:id/raw) be enabled
    # config.raw_endpoint.enabled = false

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
      qt: 'search',
      mm: '100%',
      rows: 10,
      qf: 'system_of_record_ID_tesim primary_repository_ID_tesim emory_ark_tesim local_call_number_tesim
           other_identifiers_tesim title_tesim uniform_title_tesim series_title_tesim parent_title_tesim
           creator_tesim contributors_tesim keywords_tesim subject_topics_tesim subject_names_tesim
           subject_geo_tesim subject_time_periods_tesim id',
      fq: '(((has_model_ssim:CurateGenericWork) OR (has_model_ssim:Collection)) AND !(visibility_ssi:restricted))'
      ## we want to only return works where visiblity_ssi != restricted
    }

    # solr path which will be added to solr base url before the other solr params.
    #config.solr_path = 'select'
    #config.document_solr_path = 'get'

    # items to show per page, each number in the array represent another option to choose from.
    #config.per_page = [10,20,50,100]

    # solr field configuration for search results/index views
    config.index.title_field = 'title_tesim'
    #config.index.display_type_field = 'format'
    config.index.thumbnail_field = 'hasRelatedImage_ssim'

    config.add_results_document_tool(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    config.add_show_tools_partial(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)
    #config.add_show_tools_partial(:email, callback: :email_action, validator: :validate_email_params)
    #config.add_show_tools_partial(:sms, if: :render_sms_action?, callback: :sms_action, validator: :validate_sms_params)
    config.add_show_tools_partial(:citation)
    config.add_show_tools_partial(:help, partial: 'help_link')
    config.add_show_tools_partial(:feedback, partial: 'feedback_link')

    config.add_nav_action(:advanced_search, partial: '/nav/advanced_search')
    config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: :render_bookmarks_control?)
    config.add_nav_action(:search_history, partial: 'blacklight/nav/search_history')

    # solr field configuration for document/show views
    #config.show.title_field = 'title_tsim'
    #config.show.display_type_field = 'format'
    #config.show.thumbnail_field = 'thumbnail_path_ss'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate alphabetically across a large set of results)
    # :index_range can be an array or range of prefixes that will be used to create the navigation (note: It is case sensitive when searching values)

    config.add_facet_field 'holding_repository_sim', limit: 5, label: 'Library'
    config.add_facet_field 'member_of_collections_ssim', limit: 5, label: 'Collection'
    config.add_facet_field 'creator_sim', limit: 5, label: 'Creator'
    config.add_facet_field 'human_readable_content_type_ssim', limit: 5, label: 'Format'
    config.add_facet_field 'content_genres_sim', limit: 5, label: 'Genre'
    config.add_facet_field 'primary_language_sim', limit: 5, label: 'Language'
    config.add_facet_field 'year_for_lux_isim', label: 'Date',
                                                range: {
                                                  assumed_boundaries: [1000, Time.zone.now.year],
                                                  maxlength: 4
                                                }
    config.add_facet_field 'subject_topics_sim', limit: 5, label: 'Subject - Topics'
    config.add_facet_field 'subject_names_sim', limit: 5, label: 'Subject - Names'
    config.add_facet_field 'subject_geo_sim', limit: 5, label: 'Subject - Geographic'
    config.add_facet_field 'human_readable_rights_statement_ssim', label: 'Rights Status'
    config.add_facet_field 'visibility_group_ssi', label: 'Access'
    config.add_facet_field 'contributors_sim', label: 'Contributors', show: false
    config.add_facet_field 'keywords_sim', label: 'Keywords', show: false

    #config.add_facet_field 'pub_date_ssim', label: 'Publication Year', single: true
    #config.add_facet_field 'subject_ssim', label: 'Topic', limit: 20, index_range: 'A'..'Z'
    #config.add_facet_field 'language_ssim', label: 'Language', limit: true

    # config.add_facet_field 'example_pivot_field', label: 'Pivot Field', pivot: ['format', 'language_ssim']

    #config.add_facet_field 'example_query_facet_field', label: 'Publish Date', query: {
    #  years_5: { label: 'within 5 Years', fq: "pub_date_ssim:[#{Time.zone.now.year - 5} TO *]" },
    #  years_10: { label: 'within 10 Years', fq: "pub_date_ssim:[#{Time.zone.now.year - 10} TO *]" },
    #  years_25: { label: 'within 25 Years', fq: "pub_date_ssim:[#{Time.zone.now.year - 25} TO *]" }
    #}

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    # config.add_index_field 'title_tesim', label: 'Title'

    config.add_index_field 'holding_repository_tesim', label: 'Library', if: :display_library?
    config.add_index_field 'creator_tesim', label: 'Creator', if: :display_creator?
    config.add_index_field 'human_readable_date_created_tesim', label: 'Date', if: :display_date?
    config.add_index_field 'human_readable_content_type_ssim', label: 'Format'
    config.add_index_field 'visibility_group_ssi', label: 'Access', if: :display_access?

    def display_library?(_field_config, document)
      document["has_model_ssim"] == ["Collection"]
    end

    def display_creator?(_field_config, document)
      document["has_model_ssim"] == ["CurateGenericWork"]
    end

    def display_date?(_field_config, document)
      !document["child_works_for_lux_tesim"] && document["has_model_ssim"] == ["CurateGenericWork"]
    end

    def display_access?(_field_config, document)
      !document["child_works_for_lux_tesim"] && document["has_model_ssim"] == ["CurateGenericWork"]
    end

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    # For "About this item" section of show page
    config.add_show_field 'uniform_title_tesim', label: 'Uniform Title'
    config.add_show_field 'series_title_tesim', label: 'Series Title'
    config.add_show_field 'parent_title_tesim', label: 'Title of Parent Work'
    config.add_show_field 'creator_tesim', label: 'Creator', link_to_facet: 'creator_sim'
    config.add_show_field 'contributors_tesim', label: 'Contributor', link_to_facet: 'contributors_sim'
    config.add_show_field 'human_readable_date_created_tesim', label: 'Date Created'
    config.add_show_field 'human_readable_date_issued_tesim', label: 'Date Published / Issued'
    config.add_show_field 'human_readable_data_collection_dates_tesim', label: 'Data Collection Dates'
    config.add_show_field 'human_readable_content_type_ssim', label: 'Format', link_to_facet: true
    config.add_show_field 'content_genres_tesim', label: 'Genre', link_to_facet: 'content_genres_sim'
    config.add_show_field 'extent_tesim', label: 'Extent / Dimensions'
    config.add_show_field 'primary_language_tesim', label: 'Primary Language', link_to_facet: "primary_language_sim"
    config.add_show_field 'notes_tesim', label: 'Note'
    config.add_show_field 'abstract_tesim', label: 'Description / Abstract'
    config.add_show_field 'table_of_contents_tesim', label: 'Table of Contents'
    # For "About This Collection" section of show page
    config.add_show_field 'finding_aid_link_ssm', label: 'Learn More'
    # For "Subjects / Keywords" section of show page
    config.add_show_field 'subject_topics_tesim', label: 'Subject - Topics', link_to_facet: 'subject_topics_sim'
    config.add_show_field 'subject_names_tesim', label: 'Subject - Names', link_to_facet: 'subject_names_sim'
    config.add_show_field 'subject_geo_tesim', label: 'Subject - Geographic Locations', link_to_facet: 'subject_geo_sim'
    config.add_show_field 'subject_time_periods_tesim', label: 'Subject - Time Periods'
    config.add_show_field 'keywords_tesim', label: 'Keywords', link_to_facet: 'keywords_sim'
    # For "Find this Item" section of show page
    config.add_show_field 'id', label: 'Persistent URL'
    config.add_show_field 'system_of_record_ID_tesim', label: 'System of Record ID'
    config.add_show_field 'emory_ark_tesim', label: 'Emory ARK'
    config.add_show_field 'other_identifiers_tesim', label: 'Other Identifiers'
    config.add_show_field 'institution_tesim', label: 'Institution'
    config.add_show_field 'holding_repository_tesim', label: 'Library', link_to_facet: 'holding_repository_sim'
    config.add_show_field 'administrative_unit_tesim', label: 'Administrative Unit'
    config.add_show_field 'sublocation_tesim', label: 'Sublocation'
    config.add_show_field 'local_call_number_tesim', label: 'Call Number'
    config.add_show_field 'contact_information_tesim', label: 'Contact Information'
    # For "Publication Details" section of show page
    config.add_show_field 'publisher_tesim', label: 'Publisher'
    config.add_show_field 'final_published_versions_tesim', label: 'Final Published Version'
    config.add_show_field 'publisher_version_tesim', label: 'Version of Publication'
    config.add_show_field 'place_of_production_tesim', label: 'Place of Publication / Production'
    config.add_show_field 'volume_tesim', label: 'Volume'
    config.add_show_field 'edition_tesim', label: 'Edition'
    config.add_show_field 'issue_tesim', label: 'Issue'
    config.add_show_field 'page_range_start_tesim', label: 'Start Page'
    config.add_show_field 'page_range_end_tesim', label: 'End Page'
    config.add_show_field 'issn_tesim', label: 'ISSN'
    config.add_show_field 'isbn_tesim', label: 'ISBN'
    # For "Additional Details" section of show page
    config.add_show_field 'human_readable_conference_dates_tesim', label: 'Conference Dates'
    config.add_show_field 'conference_name_tesim', label: 'Event / Conference Name'
    config.add_show_field 'sponsor_tesim', label: 'Sponsor'
    config.add_show_field 'data_producers_tesim', label: 'Data Producer'
    config.add_show_field 'grant_agencies_tesim', label: 'Grant / Funding Agency'
    config.add_show_field 'grant_information_tesim', label: 'Grant / Funding Information'
    config.add_show_field 'author_notes_tesim', label: 'Author Notes'
    config.add_show_field 'data_source_notes_tesim', label: 'Data Source Notes'
    config.add_show_field 'geographic_unit_tesim', label: 'Geographic Level for Dataset'
    config.add_show_field 'technical_note_tesim', label: 'Technical Note'
    # For "Related Material" section of show page
    config.add_show_field 'related_material_notes_tesim', label: 'Related Material'
    config.add_show_field 'related_publications_tesim', label: 'Related Publications'
    config.add_show_field 'related_datasets_tesim', label: 'Related Datasets'
    # For "Access and Copyright " section of show page
    config.add_show_field 'emory_rights_statements_tesim', label: 'Rights Statement'
    config.add_show_field 'human_readable_rights_statement_tesim', label: 'Rights Status'
    config.add_show_field 'rights_holders_tesim', label: 'Rights Holder'
    config.add_show_field 'human_readable_copyright_date_tesim', label: 'Copyright Date'
    config.add_show_field 'human_readable_re_use_license_tesim', label: 'Re-Use License'
    config.add_show_field 'access_restriction_notes_tesim', label: 'Access Restrictions'
    # For "This item is part of:" section of show page
    config.add_show_field 'member_of_collections_ssim'
    config.add_show_field 'member_of_collection_ids_ssim'
    config.add_show_field 'parent_work_for_lux_tesim'
    # For "View items in this digital collection" section of show page
    config.add_show_field 'title_tesim'
    # For "This item contains:" section of show page
    config.add_show_field 'child_works_for_lux_tesim'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field('common_fields', label: 'Common Fields') do |field|
      field.include_in_advanced_search = false
    end

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    # config.add_search_field('title') do |field|
    #   # solr_parameters hash are sent to Solr as ordinary url query params.
    #   field.solr_parameters = {
    #     'spellcheck.dictionary': 'title',
    #     qf: '${title_qf}',
    #     pf: '${title_pf}'
    #   }
    # end

    id_fields =       ['system_of_record_ID_tesim', 'primary_repository_ID_tesim', 'emory_ark_tesim',
                       'local_call_number_tesim', 'other_identifiers_tesim']
    title_fields =    ['title_tesim', 'uniform_title_tesim', 'series_title_tesim', 'parent_title_tesim']
    creator_fields =  ['creator_tesim', 'contributors_tesim']
    subject_fields =  ['keywords_tesim', 'subject_topics_tesim', 'subject_names_tesim', 'subject_geo_tesim',
                       'subject_time_periods_tesim']
    misc_fields =     ['institution_tesim', 'primary_language_tesim', 'publisher_tesim', 'holding_repository_tesim',
                       'related_material_notes_tesim', 'place_of_production_tesim', 'administrative_unit_tesim',
                       'conference_name_tesim', 'sublocation_tesim', 'sponsor_tesim', 'data_producers_tesim',
                       'grant_agencies_tesim', 'content_genres_tesim', 'grant_information_tesim', 'author_notes_tesim',
                       'notes_tesim', 'data_source_notes_tesim', 'geographic_unit_tesim', 'technical_note_tesim',
                       'issn_tesim', 'isbn_tesim', 'abstract_tesim', 'related_publications_tesim', 'related_datasets_tesim',
                       'table_of_contents_tesim']

    config.add_search_field('all_fields_advanced', label: 'All Fields') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: (id_fields + title_fields + creator_fields + subject_fields + misc_fields).join(' '),
        pf: ''
      }
    end

    config.add_search_field('title', label: 'Title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: title_fields.join(' '),
        pf: ''
      }
    end

    config.add_search_field('creator', label: 'Creator') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: creator_fields.join(' '),
        pf: ''
      }
    end

    config.add_search_field('subject', label: 'Subject') do |field|
      field.include_in_advanced_search = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: subject_fields.join(' '),
        pf: ''
      }
    end

    config.add_search_field('all_fields', label: 'All Fields') do |field|
      field.include_in_advanced_search = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: (id_fields + title_fields + creator_fields + subject_fields + misc_fields).join(' '),
        pf: ''
      }
    end

    config.add_search_field('subject_topics', label: 'Subject - Topics') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'subject_topics_tesim',
        pf: ''
      }
    end

    config.add_search_field('subject_names', label: 'Subject - Names') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'subject_names_tesim',
        pf: ''
      }
    end

    config.add_search_field('subject_geo', label: 'Subject - Geographic Locations') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'subject_geo_tesim',
        pf: ''
      }
    end

    config.add_search_field('subject_time_periods', label: 'Subject - Time Periods') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'subject_time_periods_tesim',
        pf: ''
      }
    end

    config.add_search_field('keywords', label: 'Keywords') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'keywords_tesim',
        pf: ''
      }
    end

    config.add_search_field('table_of_contents', label: 'Table of Contents') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'table_of_contents_tesim',
        pf: ''
      }
    end

    config.add_search_field('abstract', label: 'Description / Abstract') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'abstract_tesim',
        pf: ''
      }
    end

    config.add_search_field('publisher', label: 'Publisher') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'publisher_tesim',
        pf: ''
      }
    end

    config.add_search_field('content_genres', label: 'Genre') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'content_genres_tesim',
        pf: ''
      }
    end

    config.add_search_field('notes', label: 'Note') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'notes_tesim',
        pf: ''
      }
    end

    config.add_search_field('author_notes', label: 'Author Notes') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'author_notes_tesim',
        pf: ''
      }
    end

    config.add_search_field('grant_information_notes', label: 'Grant / Funding Information') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'grant_information_tesim',
        pf: ''
      }
    end

    config.add_search_field('technical_note', label: 'Technical Note') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'technical_note_tesim',
        pf: ''
      }
    end

    config.add_search_field('data_source_notes', label: 'Data Source Notes') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'data_source_notes_tesim',
        pf: ''
      }
    end

    config.add_search_field('related_material_notes', label: 'Related Material') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        qf: 'related_material_notes_tesim',
        pf: ''
      }
    end

    # config.add_search_field('author') do |field|
    #   field.solr_parameters = {
    #     'spellcheck.dictionary': 'author',
    #     qf: '${author_qf}',
    #     pf: '${author_pf}'
    #   }
    # end

    # # Specifying a :qt only to show it's possible, and so our internal automated
    # # tests can test it. In this case it's the same as
    # # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    # config.add_search_field('subject') do |field|
    #   field.qt = 'search'
    #   field.solr_parameters = {
    #     'spellcheck.dictionary': 'subject',
    #     qf: '${subject_qf}',
    #     pf: '${subject_pf}'
    #   }
    # end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, year_for_lux_ssi desc, title_ssort asc', label: 'Relevance'
    config.add_sort_field 'year_for_lux_ssi asc, title_ssort asc', label: 'Date (oldest)'
    config.add_sort_field 'year_for_lux_ssi desc, title_ssort asc', label: 'Date (newest)'
    config.add_sort_field 'creator_ssort asc', label: 'Creator (A-Z)'
    config.add_sort_field 'creator_ssort desc', label: 'Creator (Z-A)'
    config.add_sort_field 'title_ssort asc, year_for_lux_ssi desc', label: 'Title (A-Z)'
    config.add_sort_field 'title_ssort desc, year_for_lux_ssi desc', label: 'Title (Z-A)'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggestor
    # config.autocomplete_enabled = true
    # config.autocomplete_path = 'suggest'
    # if the name of the solr.SuggestComponent provided in your solrcongig.xml is not the
    # default 'mySuggester', uncomment and provide it below
    # config.autocomplete_suggester = 'mySuggester'
  end
end
