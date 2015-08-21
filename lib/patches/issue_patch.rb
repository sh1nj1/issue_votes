module KohaSuomiIssueVotes
  module Patches
  # Patches or modifies Redmine core dynamically
    module IssuePatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          has_many :issue_votes, :class_name => 'IssueVote', :dependent => :destroy, :inverse_of => :issue

        end
      end

      module InstanceMethods

        # Adds a vote for this issue for the current user. No params needed (user = user.Current).
        def vote
          # Get the vote weight custom field value for this user.
          weight_custom_field = CustomField.find_by(:name => 'Vote weight')
          weight_value_user = 1
          if weight_custom_field
            weight_value_user = User.current.custom_value_for(weight_custom_field).value
          end
          vote = IssueVote.new
          vote.user_id = User.current.id
          vote.issue_id = self.id
          vote.project_id = self.project_id
          unless weight_value_user.nil?
            vote.vote_value = weight_value_user
          end
          if vote.save
            self.update_votes_total
            logger.info('Vote cast: ' + vote.to_s)
          else
            errors = vote.errors.full_messages.to_s.gsub('[', '')
            errors = errors.gsub(']', '')
            raise Exception errors
          end
        end

        # Removes the current user's vote from this issue. No params needed (user = user.Current).
        def remove_vote
          if IssueVote.where(:user_id => User.current.id, :issue_id => self.id).delete_all
            self.update_votes_total
          else
            raise Exception 'Vote not found'
          end
        end

        # Updates the votes_total value for this issue.
        def update_votes_total
          votes = self.issue_votes
          if votes
            total = 0
            votes.each do |vote|
              total += vote.vote_value
            end
            self.votes_total = total
          end
        end

      end

    end
  end
end

unless Issue.included_modules.include?(KohaSuomiIssueVotes::Patches::IssuePatch)
  Issue.send(:include, KohaSuomiIssueVotes::Patches::IssuePatch)
end