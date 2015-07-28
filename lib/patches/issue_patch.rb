require_dependency 'issue'
module KohaSuomiIssueVotes
  module Patches
  # Patches or modifies Redmine core dynamically
    module IssuePatch
      def self.included(base) # :nodoc:
        base.class_eval do
          unloadable

#          has_many :issue_votes, :class_name => 'IssueVote', :dependent => :destroy, :inverse_of => :issue
          has_many :issue_votes, :dependent => :destroy, :inverse_of => :issue

        end

      end

    end
  end
end

#unless Issue.included_modules.include?(KohaSuomiIssueVotes::Patches::IssuePatch)
#  Issue.send(:include, KohaSuomiIssueVotes::Patches::IssuePatch)
#end