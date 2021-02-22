module Report
  module Csv
    class Member < Base
      def initialize(org, collection)
        @decorator = MemberReportDecorator.new(org, collection)
      end
    end
  end
end
