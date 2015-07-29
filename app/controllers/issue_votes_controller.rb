class IssueVotesController < ApplicationController
  unloadable

  before_filter :authorize, :only => [:index]

  def index

  end

  def vote

#    weight_custom_field = CustomField.find_by(:name => 'Vote weight')
#    if weight_custom_field
#      weight_value_user = User.current.custom_value_for(weight_custom_field).value
#  #    weight_value_user = CustomValue.where(:customized_id => User.current.id, :custom_field_id => weight_field_id)
#    end

#    vote = IssueVote.new
#    vote.user_id = User.current.id
#    vote.issue_id = params[:issue_id]
#    unless weight_value_user.nil?
#      vote.vote_value = weight_value_user
#    end
#    if vote.save
#      issue = Issue.find(vote.issue_id)
#      if issue.save
#        flash[:notice] = 'Vote registered successfully!'
#      else
#        vote.delete
#        errors = vote.errors.full_messages.to_s.gsub('[', '')
#        errors = errors.gsub(']', '')
#        flash[:error] = 'Voting failed: ' + errors
#      end
#    else
#      errors = vote.errors.full_messages.to_s.gsub('[', '')
#      errors = errors.gsub(']', '')
#      flash[:error] = 'Voting failed: ' + errors
#    end
#    redirect_to home_url + 'issues/' + vote.issue_id.to_s
    issue = Issue.find(params[:issue_id])
    begin
      issue.vote
      flash[:notice] = 'Vote registered successfully!'
    rescue AlreadyVotedException => e
      flash[:error] = e.to_s
    end
    redirect_to home_url + 'issues/' + vote.issue_id.to_s
  end

  def remove_vote
    if IssueVote.where(:user_id => User.current.id, :issue_id => params[:issue_id]).delete_all
      flash[:notice] = 'Vote removed succesfully'
    else
      flash[:error] = 'Could not find vote for the user and issue'
    end
    redirect_to home_url + 'issues/' + params[:issue_id]
  end
end