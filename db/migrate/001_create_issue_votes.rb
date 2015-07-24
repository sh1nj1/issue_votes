class CreateIssueVotes < ActiveRecord::Migration
  def change
    create_table :issue_votes do |t|
      t.integer :issue_id
      t.integer :user_id
      t.integer :vote_value, :default => 1
    end
  end
end

def self.down
  drop_table :issue_votes
end