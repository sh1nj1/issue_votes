#require_dependency 'issue_votes/AlreadyVotedException'
module KohaSuomiIssueVotes
  module Acts
    module Voteable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_voteable
          has_many :issue_votes, :as => :voteable, :dependent => :delete_all
          include KohaSuomiIssueVotes::Acts::Voteable::InstanceMethods
        end
      end

      module InstanceMethods

        def vote
          weight_custom_field = CustomField.find_by(:name => 'Vote weight')
          if weight_custom_field
            weight_value_user = User.current.custom_value_for(weight_custom_field).value
            #    weight_value_user = CustomValue.where(:customized_id => User.current.id, :custom_field_id => weight_field_id)
          end
          vote = IssueVote.new
          vote.user_id = User.current.id
          vote.issue_id = self.id
          unless weight_value_user.nil?
            vote.vote_value = weight_value_user
          end

          unless vote.save
            raise AlreadyVotedException, ''
          end
        end

      end

    end
  end
end
ActiveRecord::Base.send :include, KohaSuomiIssueVotes::Acts::Voteable #:nodoc: