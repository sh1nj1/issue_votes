require_dependency 'project'
module KohaSuomiIssueVotes
  module Patches
    # Patches or modifies Redmine core dynamically
    module ProjectPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          unloadable

          has_many :issue_votes, :class_name => 'IssueVote', :dependent => :destroy, :inverse_of => :user

        end

      end

    end
  end
end

unless Project.included_modules.include?(KohaSuomiIssueVotes::Patches::ProjectPatch)
  Project.send(:include, KohaSuomiIssueVotes::Patches::ProjectPatch)
end