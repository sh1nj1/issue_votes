require_dependency 'vote_validator'
class IssueVote < ActiveRecord::Base
  unloadable

  self.table_name = 'issue_votes'
  belongs_to :issue
  belongs_to :project
  belongs_to :user

  validates :user_id, :issue_id, presence: true

  # VoteValidator's "validate()" -method gets called when "valid()" is called on this activerecord object.
  validates_with VoteValidator

#  scope :visible, lambda { |*args|
#                  joins(issue_vote: :project).
#                    where(Project.allowed_to_condition(args.shift || User.current, :issue_vote, *args))
#                }

  acts_as_event :datetime => :created_on,
                :url => Proc.new {|o| {:controller => 'issues', :action => 'show', :id => o.issue_id}},
                :description => Proc.new {|o| 'Issue votes plugin: vote cast on issue, weight: ' "#{o.vote_value.to_s}"},
                :type => 'vote',
                :author => :user,
                :group => :issue,
                :title => Proc.new {|o| 'Vote cast: ' "#{o.issue.subject} ##{o.vote_value}"}

  acts_as_activity_provider :type => "issue_votes",
                            :scope => preload({:issue => :project}, :user).
                              joins("LEFT JOIN #{Project.table_name} ON #{IssueVote.table_name}.project_id =  #{Project.table_name}.id"),
                            :timestamp => "#{IssueVote.table_name}.created_on",
                            :author_key => "#{IssueVote.table_name}.user_id",
                            :permission => :view_vote_activities

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