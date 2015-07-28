class VoteValidator < ActiveModel::Validator
  def validate(vote)
    if vote.user_id.nil? || vote.issue_id.nil?
      vote.errors[:base] << 'One or more required fields are empty!'
    elsif IssueVote.exists?(:user_id => vote.user_id, :issue_id => vote.issue_id)
        vote.errors[:base] << 'Already voted on issue'
    end
  end
end