class CreateVotingOrganizations < ActiveRecord::Migration
  def change
    create_table :voting_organizations do |t|
      t.string :name, :null => false
      t.timestamp :created_on
    end
  end
end

def self.down
  drop_table :voting_organizations
end