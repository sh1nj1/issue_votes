module KohaSuomiIssueVotes
  module Hooks
    class HtmlHeaderHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
        return stylesheet_link_tag(:issue_votes, :plugin => 'issue_votes')
      end
    end
  end
end