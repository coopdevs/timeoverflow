module Persister
  class PostPersister
    attr_accessor :post

    def initialize(post)
      @post = post
    end

    def save
      ::ActiveRecord::Base.transaction do
        post.save!
        create_save_event!
        post
      end
    rescue ActiveRecord::RecordInvalid => _exception
      false
    end

    def update_attributes(params)
      post.update_attributes(params)
    end

    private

    def create_save_event!
      ::Event.create! action: :create, post: post
    end
  end
end
