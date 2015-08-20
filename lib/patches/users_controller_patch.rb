module KohaSuomiIssueVotes
  module Patches
    module UsersControllerPatch

      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          User.safe_attributes('voting_organization_id')

          alias_method_chain :edit, :voting_organizations

        end

      end

      module ClassMethods


      end

      module InstanceMethods
        def edit_with_voting_organizations
          @auth_sources = AuthSource.all
          @membership ||= Member.new
          @voting_organizations = VotingOrganization.all
        end
      end
    end
  end
end

unless UsersController.included_modules.include? KohaSuomiIssueVotes::Patches::UsersControllerPatch
  UsersController.send(:include, KohaSuomiIssueVotes::Patches::UsersControllerPatch)
end
