require 'issue'
module KohaSuomiVote
  # Patches or modifies Redmine core dynamically
  module IssuePatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable

      end

    end

    module ClassMethods
    end

    module InstanceMethods



    end
  end
end