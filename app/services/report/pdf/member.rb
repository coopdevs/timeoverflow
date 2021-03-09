module Report
  module Pdf
    class Member < Base
      def initialize(org, collection)
        self.decorator = MemberReportDecorator.new(org, collection)
      end
    end
  end
end
