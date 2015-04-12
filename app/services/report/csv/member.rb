module Report
  module CSV
    class Member
      def initialize(collection)
        @collection = collection
      end

      def run
        member_report = MemberReportDecorator.new(@collection)
        Report::CSV.run(member_report.headers, member_report.rows)
      end
    end
  end
end
