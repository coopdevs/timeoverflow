module Persister
  class MemberPersister
    attr_accessor :member

    def initialize(member)
      @member = member
    end

    def save
      ::ActiveRecord::Base.transaction do
        member.save!
        create_save_event!
        member
      end
    rescue ActiveRecord::RecordInvalid => _exception
      false
    end

    def update_attributes(params)
      ::ActiveRecord::Base.transaction do
        member.update_attributes!(params)
        create_update_event!
        member
      end
    rescue ActiveRecord::RecordInvalid => _exception
      false
    end

    private

    def create_save_event!
      ::Event.create! action: :created, member: member
    end

    def create_update_event!
      ::Event.create! action: :updated, member: member
    end
  end
end
