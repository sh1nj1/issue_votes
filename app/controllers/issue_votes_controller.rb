class IssueVotesController < ApplicationController
  unloadable
  
  # Permissions are often based on the project in question. Ensure that we have a
  # project before authorizing the current user against it.
  before_filter :get_project, :authorize

  # The index displays a given issue's votes in 2 distinct tables.
  def index
    @issue_id = params[:issue_id]
    @votes = IssueVote.where(:issue_id => @issue_id)
#    @user_votes = []
    @votes_rows = []
    @votes_rows_org = {}

    # Create model (rows) for the votes report table.
    @votes.each do |vote|
      vote_user = User.find(vote.user_id)
      vote_org = AuthOrganization.find(vote_user.auth_organization_id).name
      user_vote = {
        :user_id => vote_user.id,
        :login => vote_user.login,
        :name => vote_user.firstname + ' ' + vote_user.lastname,
        :mail => vote_user.mail,
        :voted_on => vote.created_on,
        :vote_value => vote.vote_value
      }
      @votes_rows << user_vote
      if @votes_rows_org[vote_org]
        @votes_rows_org[vote_org] += vote.vote_value
      else
        @votes_rows_org[vote_org] = vote.vote_value
      end
    end
  end

  # Voting action for the parameter-given issue.
  def vote
    issue = Issue.find(params[:issue_id])
    if issue.nil?
      flash[:error] = 'Issue not found.'
      redirect_to home_url + issues
    else
      begin
        issue.vote
        issue.save
        flash[:notice] = 'Vote added successfully!'
      rescue Exception => e
        flash[:error] = 'Voting failed: ' + e.to_s
      end
    end
    redirect_to home_url + 'issues/' + params[:issue_id]
  end

  # Vote removal action for the parameter-given issue.
  def remove_vote
    issue = Issue.find(params[:issue_id])
    if issue.nil?
      flash[:error] = 'Issue not found.'
      redirect_to home_url + issues
    else
      begin
        issue.remove_vote
        issue.save
        flash[:notice] = 'Vote removed successfully!'
      rescue Exception => e
        flash[:error] = 'Vote removal failed: ' + e.to_s
      end
    end
    redirect_to home_url + 'issues/' + params[:issue_id]
  end

  def get_project
    @project = Issue.find(params[:issue_id]).project
  end

end