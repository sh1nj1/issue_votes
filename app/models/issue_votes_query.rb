# Copyright (C) 2015 vaarakirjastot.fi
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class IssueVotesQuery < Query

  self.queried_class = Issue

  self.available_columns = [
    QueryColumn.new(:id, :sortable => "#{User.table_name}.id", :default_order => 'desc', :caption => '#', :frozen => true),
    QueryColumn.new(:name, :sortable => "#{User.table_name}.name", :default_order => 'desc'),
    QueryColumn.new(:organization, :sortable => lambda {User.custom_value_for('Voting organization')}, :groupable => true),
    QueryColumn.new(:vote_weight, :sortable => "#{IssueVote.table_name}.vote_value"),
    QueryColumn.new(:date, :sortable => "#{IssueVote.table_name}.created_on")
  ]

  def initialize(attributes=nil, *args)
    super attributes
    self.filters ||= { 'status_id' => {:operator => "o", :values => [""]} }
  end

  # Returns true if the query is visible to +user+ or the current user.
  def visible?(user=User.current)
    return true if user.admin?
    return false unless project.nil? || user.allowed_to?(:view_issues, project)
    case visibility
      when VISIBILITY_PUBLIC
        true
      when VISIBILITY_ROLES
        if project
          (user.roles_for_project(project) & roles).any?
        else
          Member.where(:user_id => user.id).joins(:roles).where(:member_roles => {:role_id => roles.map(&:id)}).any?
        end
      else
        user == self.user
    end
  end

  def is_private?
    visibility == VISIBILITY_PRIVATE
  end

  def is_public?
    !is_private?
  end

  def draw_relations
    r = options[:draw_relations]
    r.nil? || r == '1'
  end

  def draw_progress_line
    r = options[:draw_progress_line]
    r == '1'
  end

  def draw_progress_line=(arg)
    options[:draw_progress_line] = (arg == '1' ? '1' : nil)
  end

  def build_from_params(params)
    super
    self.draw_relations = params[:draw_relations] || (params[:query] && params[:query][:draw_relations])
    self.draw_progress_line = params[:draw_progress_line] || (params[:query] && params[:query][:draw_progress_line])
    self
  end

  def available_columns
    return @available_columns if @available_columns
    @available_columns = self.class.available_columns.dup

    @available_columns
  end

end