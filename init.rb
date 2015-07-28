Rails.configuration.to_prepare do
  require_dependency 'hooks/issue_view_hook'
  require_dependency 'hooks/html_header_hook'
  require_dependency 'patches/issue_patch'
  require_dependency 'patches/issues_controller_votes_patch'
  require_dependency 'patches/user_patch'
end

require 'redmine'

Redmine::Plugin.register :issue_votes do
  name 'Issue votes plugin'
  author 'Juhani Seppala'
  description 'This is an amazing plugin for Redmine'
  version '0.0.1'
  url 'vaarakirjastot.fi'
  author_url 'https://github.com/jseplae'
  project_module :issue_votes do
    permission :vote_issue, :issue_votes => :vote
#    permission :view_votes, {:issues => :view_votes}, :require => :loggedin
#    permission :view_voter, {:issues => :view_voter}, :require => :loggedin
  end
end
