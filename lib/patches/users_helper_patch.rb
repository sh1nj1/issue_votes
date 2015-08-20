module KohaSuomiIssueVotes
  module Patches
    module UsersHelperPatch

      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          # Magic
          alias_method_chain :user_settings_tabs, :voting_organizations
        end
      end

      module InstanceMethods
        def user_settings_tabs_with_voting_organizations
          tabs = [{:name => 'general', :partial => 'users/general', :label => :label_general},
                  {:name => 'memberships', :partial => 'users/memberships', :label => :label_project_plural},
                  {:name => 'voting_organizations', :partial => 'voting_organizations/index', :label => :voting_organization_plural}
          ]
          if Group.givable.any?
            tabs.insert 1, {:name => 'groups', :partial => 'users/groups', :label => :label_group_plural}
          end
          tabs
        end
      end
    end
  end
end

unless UsersHelper.included_modules.include?(KohaSuomiIssueVotes::Patches::UsersHelperPatch)
  UsersHelper.send(:include, KohaSuomiIssueVotes::Patches::UsersHelperPatch)
end
