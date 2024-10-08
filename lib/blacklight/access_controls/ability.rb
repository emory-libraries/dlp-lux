# frozen_string_literal: true

require 'cancan'

module Blacklight
  module AccessControls
    module Ability
      extend ActiveSupport::Concern

      included do
        include CanCan::Ability
        include Blacklight::AccessControls::PermissionsQuery

        # Once you include this module, you can add custom
        # permission methods to ability_logic, like so:
        # self.ability_logic += [:setup_my_permissions]
        class_attribute :ability_logic
        self.ability_logic = %i[discover_permissions read_permissions download_permissions]
      end

      def initialize(user, options = {})
        @current_user = user || guest_user
        @options = options
        @cache = Blacklight::AccessControls::PermissionsCache.new
        grant_permissions
      end

      attr_reader :current_user, :options, :cache

      def self.user_class
        Blacklight::AccessControls.config.user_model.constantize
      end

      # A user who isn't logged in
      def guest_user
        Blacklight::AccessControls::Ability.user_class.new
      end

      def grant_permissions
        Rails.logger.debug('Usergroups are ' + user_groups.inspect)
        ability_logic.each do |method|
          send(method)
        end
      end

      def discover_permissions
        can :discover, String do |id|
          test_discover(id)
        end

        can :discover, SolrDocument do |obj|
          cache.put(obj.id, obj)
          test_discover(obj.id)
        end
      end

      def read_permissions
        # Loading an object from your datastore might be slow (e.g. Fedora), so assume that if a string is passed, it's an object id
        can :read, String do |id|
          test_read(id)
        end

        can :read, SolrDocument do |obj|
          cache.put(obj.id, obj)
          test_read(obj.id)
        end
      end

      def download_permissions
        can :download, String do |id|
          test_download(id)
        end

        can :download, SolrDocument do |obj|
          cache.put(obj.id, obj)
          test_download(obj.id)
        end
      end

      def test_discover(id)
        Rails.logger.debug("[CANCAN] Checking discover permissions for user: #{current_user.user_key} with groups: #{user_groups.inspect}")
        group_intersection = user_groups & discover_groups(id)
        !group_intersection.empty? || discover_users(id).include?(current_user.user_key)
      end

      def test_read(id)
        Rails.logger.debug("[CANCAN] Checking read permissions for user: #{current_user.user_key} with groups: #{user_groups.inspect}")
        group_intersection = user_groups & read_groups(id)
        !group_intersection.empty? || read_users(id).include?(current_user.user_key)
      end

      def test_download(id)
        Rails.logger.debug("[CANCAN] Checking download permissions for user: #{current_user.user_key} with groups: #{user_groups.inspect}")
        group_intersection = user_groups & download_groups(id)
        !group_intersection.empty? || download_users(id).include?(current_user.user_key)
      end

      # You can override this method if you are using a different AuthZ (such as LDAP)
      def user_groups
        return @user_groups if @user_groups

        @user_groups = default_user_groups
        @user_groups |= current_user.groups if current_user.respond_to? :groups
        user_groups_customizations

        @user_groups
      end

      def user_groups_customizations
        @user_groups |= ['registered', 'emory_low'] unless current_user.new_record?
        #NOTE: The user's IP address got passed in through the options hash
        @user_groups |= rose_user_groups if rose_reading_room_ips.include? options
        @user_groups |= admin_user_groups if admin_uids.include? current_user.uid
      end

      # Everyone is automatically a member of groups 'public' and 'low_res'
      def default_user_groups
        ['public', 'low_res']
      end

      # Only users accessing content from the Rose reading room IP should be added to the 'rose_high' access group
      def rose_user_groups
        ['rose_high']
      end

      def admin_user_groups
        ['admin']
      end

      # read implies discover, so discover_groups is the union of read and discover groups
      def discover_groups(id)
        doc = permissions_doc(id)
        return [] if doc.nil?
        dg = read_groups(id) | (doc[self.class.discover_group_field] || [])
        Rails.logger.debug("[CANCAN] discover_groups: #{dg.inspect}")
        dg
      end

      # read implies discover, so discover_users is the union of read and discover users
      def discover_users(id)
        doc = permissions_doc(id)
        return [] if doc.nil?
        dp = read_users(id) | (doc[self.class.discover_user_field] || [])
        Rails.logger.debug("[CANCAN] discover_users: #{dp.inspect}")
        dp
      end

      # download access implies read access, so read_groups is the union of download and read groups.
      def read_groups(id)
        doc = permissions_doc(id)
        return [] if doc.nil?
        rg = download_groups(id) | Array(doc[self.class.read_group_field])
        Rails.logger.debug("[CANCAN] read_groups: #{rg.inspect}")
        rg
      end

      # download access implies read access, so read_users is the union of download and read users.
      def read_users(id)
        doc = permissions_doc(id)
        return [] if doc.nil?
        rp = download_users(id) | Array(doc[self.class.read_user_field])
        Rails.logger.debug("[CANCAN] read_users: #{rp.inspect}")
        rp
      end

      def download_groups(id)
        doc = permissions_doc(id)
        return [] if doc.nil?
        dg = Array(doc[self.class.download_group_field])
        Rails.logger.debug("[CANCAN] download_groups: #{dg.inspect}")
        dg
      end

      def download_users(id)
        doc = permissions_doc(id)
        return [] if doc.nil?
        dp = Array(doc[self.class.download_user_field])
        Rails.logger.debug("[CANCAN] download_users: #{dp.inspect}")
        dp
      end

      def rose_reading_room_ips
        reading_room_ips["all_reading_room_ips"]["rose_reading_room_ip_list"]
      end

      def reading_room_ips
        @reading_room_ips ||= reading_room_ips_yaml.with_indifferent_access
      end

      def reading_room_ips_yaml
        ::Blacklight::SearchParamsYamlCoder.yaml_load(
          ERB.new(File.read(Rails.root.join("config", "reading_room_ips.yml"))).result
        )
      end

      def admin_uids
        YAML.load_file(Rails.root.join("config", "emory", "groups", "admins.yml"))['admin']
      rescue
        []
      end

      def admin?
        user_groups.include? 'admin'
      end

      module ClassMethods
        def discover_group_field
          Blacklight::AccessControls.config.discover_group_field
        end

        def discover_user_field
          Blacklight::AccessControls.config.discover_user_field
        end

        def read_group_field
          Blacklight::AccessControls.config.read_group_field
        end

        def read_user_field
          Blacklight::AccessControls.config.read_user_field
        end

        def download_group_field
          Blacklight::AccessControls.config.download_group_field
        end

        def download_user_field
          Blacklight::AccessControls.config.download_user_field
        end
      end
    end
  end
end
