module Report
  module Pdf
    class Member < Base
      def initialize(org, collection)
        self.decorator = Report::MemberDecorator.new(org, collection)
      end
    end
  end
end
