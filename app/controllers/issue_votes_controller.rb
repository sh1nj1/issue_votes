class IssueVotesController < ApplicationController
  unloadable
  
  # Permissions are often based on the project in question. Ensure that we have a
  # project before authorizing the current user against it.
  before_filter :get_project, :authorize

  # The index displays a given issue's votes in 2 distinct tables.
  def index
    issue_id = params[:issue_id]

    # Get the models
    @votes_rows = get_votes_report_user_model(issue_id)
    @votes_rows_org = get_votes_report_org_model(issue_id)

    respond_to do |format|
      format.html { render :template => 'issue_votes/index' }
      format.csv  { send_data(votes_to_csv, :type => 'text/csv; header=present', :filename => 'votes-issue-' + issue_id + '.csv') }
    end

  end

  # Voting action for the parameter-given issue.
  def vote
    issue = Issue.find(params[:issue_id])
    vote_value = params[:vote_value].to_i
    if issue.nil?
      flash[:error] = 'Issue not found.'
      redirect_to home_url + 'issues/'
    else
      begin
        issue.vote(vote_value)
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
      redirect_to home_url + 'issues/'
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

  # Prepares and returns a csv-file from the given issue's votes.
  def votes_to_csv
    encoding = l(:general_csv_encoding)
    columns = ['Login', 'Name', 'Email', 'Vote date', 'Vote weight']
    columns_orgs = ['Organization', 'Votes']
    @votes_rows = get_votes_report_user_model(params[:issue_id])
    @votes_rows_org = get_votes_report_org_model(params[:issue_id])

    if @votes_rows.count > 0
      export = CSV.generate(:col_sep => l(:general_csv_separator)) do |csv|
        # csv header fields
        csv << @votes_rows.first.keys
        # csv lines
        @votes_rows.each do |hash|
          csv << hash.values
        end

        # Add empty row before the org content
        csv << [' ']
        csv << columns_orgs
        @votes_rows_org.each do |row|
          csv << row
        end
      end
      export
    end
  end

  # Create and return a model (rows) for the votes report table.
  def get_votes_report_user_model(issue_id)
    @issue_id = issue_id
    @votes = IssueVote.where(:issue_id => @issue_id)
    @votes_rows = []
    @votes.each do |vote|
      vote_user = User.find(vote.user_id)
      user_vote = {
        :user_id => vote_user.id,
        :Login => vote_user.login,
        :Name => vote_user.firstname + ' ' + vote_user.lastname,
        :Mail => vote_user.mail,
        :'Voted on' => vote.created_on,
        :'Vote value' => vote.vote_value
      }
      @votes_rows << user_vote
    end
    @votes_rows
  end

  # Create and return a model (rows) for the votes report table (organization).
  def get_votes_report_org_model(issue_id)
    @issue_id = issue_id
    @votes = IssueVote.where(:issue_id => @issue_id)
    @votes_rows_org = {}
    @votes.each do |vote|
      vote_user = User.find(vote.user_id)
#      vote_org = VotingOrganization.where(vote_user.voting_organization_id).take
      vote_org = vote_user.voting_organization
      if vote_org
        vote_org_name = vote_org.name
        @votes_rows_org[vote_org_name] ? @votes_rows_org[vote_org_name] += vote.vote_value : @votes_rows_org[vote_org_name] = vote.vote_value
      else
        @votes_rows_org[l(:independent)] ? @votes_rows_org[l(:independent)] += vote.vote_value : @votes_rows_org[l(:independent)] = vote.vote_value
      end
    end
    @votes_rows_org
  end

  private :get_votes_report_user_model, :get_votes_report_org_model

end