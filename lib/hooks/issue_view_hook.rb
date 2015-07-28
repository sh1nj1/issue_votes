module KohaSuomiIssueVotes
  module Hooks
    class IssueVoteHook < Redmine::Hook::ViewListener
      render_on :view_issues_show_details_bottom, :partial => 'vote_issue'
    end
  end
end
