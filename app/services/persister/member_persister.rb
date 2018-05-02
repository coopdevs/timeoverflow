module Persister
  class MemberPersister
    attr_accessor :member

    def initialize(member)
      @member = member
    end

    def save
      member.save
    end
  end
end
