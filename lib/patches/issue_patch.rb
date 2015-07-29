require 'acts_as_voteable'
module KohaSuomiIssueVotes
  module Patches
  # Patches or modifies Redmine core dynamically
    module IssuePatch
      def self.included(base) # :nodoc:
        base.class_eval do
          unloadable

          acts_as_voteable
#          has_many :issue_votes, :class_name => 'IssueVote', :dependent => :destroy, :inverse_of => :issue
#          has_many :issue_votes, :as => :voteable, :dependent => :destroy, :inverse_of => :issue

        end

      end

    end
  end
end

unless Issue.included_modules.include?(KohaSuomiIssueVotes::Patches::IssuePatch)
  Issue.send(:include, KohaSuomiIssueVotes::Patches::IssuePatch)
end