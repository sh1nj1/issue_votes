# Create a table to maintain information on individual votes cast
class CreateIssueVotes < ActiveRecord::Migration
  def change
    create_table :issue_votes do |t|
      t.integer :issue_id
      t.integer :user_id
      t.column :voteable_type, :string, :default => '', :null => false
      t.column :voteable_id, :integer, :default => 0, :null => false
      t.integer :vote_value, :default => 1
    end
    add_index :issue_votes, [:user_id], :name => 'fk_issue_votes_user'
    add_index :issue_votes, [:voteable_id, :voteable_type], :name => 'fk_issue_votes_voteable'
  end
end

def self.down
  drop_table :issue_votes
end