# Add auth organization column to the users table.
class AddVotingOrganizationIdColumn < ActiveRecord::Migration
  def change
    add_column :users, :voting_organization_id, :integer, :null => true
  end
end

def self.down
  remove_column :users, :voting_organization_id
end