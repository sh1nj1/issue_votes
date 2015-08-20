# Class VotingOrganization corresponds to the users's voting organization used
# when voting & in the reports view.
class VotingOrganization < ActiveRecord::Base
  unloadable

  self.table_name = 'voting_organizations'
  has_many :users, :class_name => 'User', :dependent => :nullify

  validates :name, presence: true, uniqueness: true
  attr_protected :id
  attr_accessible :name

end