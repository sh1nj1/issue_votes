class IssueVotesController < ApplicationController
  unloadable

  before_filter :authorize, :only => [:index]

  def index

  end

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

end