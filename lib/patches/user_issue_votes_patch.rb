require_dependency 'user'
module KohaSuomiIssueVotes
  module Patches
    # Patches or modifies Redmine core dynamically
    module UserIssueVotesPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          has_many :issue_votes, :class_name => 'IssueVote', :dependent => :destroy, :inverse_of => :user
          belongs_to :voting_organization, :class_name => 'VotingOrganization', :inverse_of => :users

          before_destroy :update_votes_total

        end

      end

      module ClassMethods

      end

      module InstanceMethods

        # Finds this user's vote for the given issue or returns nil
        def find_vote(issue_id)
          nil if issue_id.nil?

          IssueVote.find_by(:user_id => self.id, :issue_id => issue_id)
        end

        # Update issues's total votes upon user deletion.
        def update_votes_total
          votes = self.issue_votes
          if votes
            votes.each do |vote|
              issue = vote.issue
              if issue
                issue.update_votes_total
              end
            end
          end
        end

      end
    end
  end
end

unless User.included_modules.include?(KohaSuomiIssueVotes::Patches::UserIssueVotesPatch)
  User.send(:include, KohaSuomiIssueVotes::Patches::UserIssueVotesPatch)
end