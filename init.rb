Rails.configuration.to_prepare do
  require_dependency 'hooks/issue_view_hook'
  require_dependency 'hooks/html_header_hook'
  require_dependency 'patches/issue_query_patch'
  require_dependency 'patches/issue_patch'
  require_dependency 'patches/issues_controller_votes_patch'
  require_dependency 'patches/user_patch'
  require_dependency 'patches/project_patch'
end

Redmine::Plugin.register :issue_votes do
  name 'Issue votes plugin'
  author 'Juhani Seppala'
  description 'The Issue Votes plugin adds voting functionality to issues, allowing a project to include users into the development workflow'
  version '0.1.0'
  url 'vaarakirjastot.fi'
  author_url 'https://github.com/jseplae'
  project_module :issue_votes do
    permission :vote_issue, :issue_votes => [:vote, :remove_vote] # Permission to cast a vote on an issue.
    permission :view_vote_activities, :issue_votes => :index # Permission to view users's votes in a project's /activities -tab.
    permission :view_votes, :issue_votes => :index # Permission to view voting report for an issue.
  end
  Redmine::Activity.map do |activity|
    activity.register(:issue_votes, {:class_name => 'IssueVote'})
  end
end
