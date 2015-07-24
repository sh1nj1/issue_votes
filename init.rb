Rails.configuration.to_prepare do

end

Redmine::Plugin.register :issue_votes do
  name 'Issue votes plugin'
  author 'Juhani Seppala'
  description 'This is an amazing plugin for Redmine'
  version '0.0.1'
  url 'vaarakirjastot.fi'
  author_url 'https://github.com/jseplae'
end
