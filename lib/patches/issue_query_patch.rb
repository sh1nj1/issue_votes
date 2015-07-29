require_dependency 'query'

module KohaSuomiIssueVotes
  module Patches
    module IssueQueryPatch

      def self.included(base) # :nodoc:
        base.class_eval do

          unloadable

          self.available_colums << QueryColumn.new(:votes_total, :sortable => "#{Issue.table_name}.votes_total"))

        end


      end

    end
  end
end

unless IssueQuery.included_modules.include?(KohaSuomiIssueVotes::Patches::IssueQueryPatch)
  IssueQuery.send(:include, KohaSuomiIssueVotes::Patches::IssueQueryPatch)
end
