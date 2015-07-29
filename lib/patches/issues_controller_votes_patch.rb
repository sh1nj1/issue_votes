module KohaSuomiIssueVotes
  module Patches
    module IssuesControllerVotesPatch

      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          # Magic
          alias_method_chain :show, :votes

        end
      end

      module InstanceMethods



        def show_with_votes
          @journals = @issue.journals.includes(:user, :details).
            references(:user, :details).
            reorder("#{Journal.table_name}.id ASC").to_a
          @journals.each_with_index {|j,i| j.indice = i+1}
          @journals.reject!(&:private_notes?) unless User.current.allowed_to?(:view_private_notes, @issue.project)
          Journal.preload_journals_details_custom_fields(@journals)
          @journals.select! {|journal| journal.notes? || journal.visible_details.any?}
          @journals.reverse! if User.current.wants_comments_in_reverse_order?

          @changesets = @issue.changesets.visible.preload(:repository, :user).to_a
          @changesets.reverse! if User.current.wants_comments_in_reverse_order?

          @relations = @issue.relations.select {|r| r.other_issue(@issue) && r.other_issue(@issue).visible? }
          @allowed_statuses = @issue.new_statuses_allowed_to(User.current)
          @priorities = IssuePriority.active
          @time_entry = TimeEntry.new(:issue => @issue, :project => @issue.project)
          @relation = IssueRelation.new

          # Issue votes plugin: check the vote count this issue & test whether
          # this user has already voted on this issue
          @votes_for_issue = IssueVote.where(issue_id: @issue.id).sum(:vote_value)
          @already_voted = IssueVote.find_by(:issue_id => @issue.id, :user_id => User.current.id)

          respond_to do |format|
            format.html {
              retrieve_previous_and_next_issue_ids
              render :template => 'issues/show'
            }
            format.api
            format.atom { render :template => 'journals/index', :layout => false, :content_type => 'application/atom+xml' }
            format.pdf  {
              send_file_headers! :type => 'application/pdf', :filename => "#{@project.identifier}-#{@issue.id}.pdf"
            }
          end
        end

      end
    end
  end
end

unless IssuesController.included_modules.include?(KohaSuomiIssueVotes::Patches::IssuesControllerVotesPatch)
  IssuesController.send(:include, KohaSuomiIssueVotes::Patches::IssuesControllerVotesPatch)
end
