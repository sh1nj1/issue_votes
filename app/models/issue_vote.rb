require_dependency 'vote_validator'
class IssueVote < ActiveRecord::Base
  unloadable

  self.table_name = 'issue_votes'
  belongs_to :issue, :class_name => 'Issue', :foreign_key => 'issue_id'
  belongs_to :project, :foreign_key => 'project_id'
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'

  validates :user_id, :issue_id, presence: true
  validates_with VoteValidator

  scope :visible, lambda { |*args|
                  joins(issue_vote: :project).
                    where(Project.allowed_to_condition(args.shift || User.current, :issue_vote, *args))
                }

  acts_as_event :title => Proc.new {|o| 'Vote cast: ' "#{o.issue.name} ##{o.vote_value}"}
#  acts_as_activity_provider :type => 'issue_votes',
#                            :scope => preload(:issue_votes),
#                            :timestamp => "#{IssueVote.table_name}.created_on",
#                            :author_key => "#{IssueVote.table_name}.user_id",
#                            :permission => :vote_issue,
#                            :find_options => {:select => "#{IssueVote.table_name}.*",:include => [:user_id]}

  acts_as_activity_provider :type => "issue_votes",
                            :scope => preload({:issue_votes => :project}),
                            :timestamp => "#{IssueVote.table_name}.created_on",
                            :author_key => "#{IssueVote.table_name}.user_id",
                            :permission => :vote_issue

  acts_as_searchable :columns => ["#{table_name}.user_id"],
                     :scope => lambda { includes([:issue => :project]).order("#{table_name}.id") },
                     :project_key => "#{Issue.table_name}.project_id"

  attr_protected :id


  def project
    self.issue.project if self.issue
  end

#  def valid_vote?(user = User.current)
#    return if IssueVote.find(:user_id => user_id, :issue_id => issue_id)
#  end

end