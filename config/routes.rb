# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
#match 'issues/vote', :controller => 'issues', :action => 'vote', :via => [:get, :post]
RedmineApp::Application.routes.draw do
  match 'issue_votes/vote', :to => 'issue_votes#vote', :via => [:get, :post], :as => 'add_issue_vote'
  match 'issue_votes/remove', :to => 'issue_votes#remove_vote', :via => [:get, :post], :as => 'remove_issue_vote'
  match 'issue_votes/:issue_id', :to => 'issue_votes#index', :via => [:get], :as => 'issue_votes'
  match 'voting_organizations/new', :to => 'voting_organizations#new', :via => [:get], :as => 'new_voting_organization'
  match 'voting_organizations/create', :to => 'voting_organizations#create', :via => [:post], :as => 'create_voting_organization'
end