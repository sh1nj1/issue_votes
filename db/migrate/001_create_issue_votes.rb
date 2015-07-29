class CreateIssueVotes < ActiveRecord::Migration
  def change
    create_table :issue_votes do |t|
      t.references :issue, :null => false
      t.references :user, :null => false
      t.integer :vote_value, :default => 1
      t.references :project, :null => false
      t.timestamp :created_on
    end
  end
end

def self.down
  drop_table :issue_votes
end