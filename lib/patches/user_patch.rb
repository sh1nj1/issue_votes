require_dependency 'user'
module KohaSuomiIssueVotes
  module Patches
    # Patches or modifies Redmine core dynamically
    module UserPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          unloadable

          has_many :issue_votes, :class_name => 'IssueVote', :dependent => :destroy, :inverse_of => :user

        end

      end

    end
  end
end

unless User.included_modules.include?(KohaSuomiIssueVotes::Patches::UserPatch)
  User.send(:include, KohaSuomiIssueVotes::Patches::UserPatch)
end