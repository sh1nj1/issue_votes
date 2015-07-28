# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
#match 'issues/vote', :controller => 'issues', :action => 'vote', :via => [:get, :post]
RedmineApp::Application.routes.draw do
  match 'issue_votes/vote', :to => 'issue_votes#vote', :via => [:get, :post]
  match 'issue_votes/remove', :to => 'issue_votes#remove_vote', :via => [:get, :post]
end