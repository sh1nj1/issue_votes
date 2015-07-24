module KohaSuomiIssueVotes
  module Patches
    module CustomFieldsHelperPatch
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)

        base.class_eval do
          unloadable

          # Return a vote tag
          def vote_tag(votes_value)
            title = 'Votes'
            content = content_tag 'span', custom_value.custom_field.name, :title => title

            content_tag "label", content +
                                 (required ? " <span class=\"required\">*</span>".html_safe : ""),
                        :for => "#{name}_custom_field_values_#{custom_value.custom_field.id}"
          end
        end
      end
    end
  end
end