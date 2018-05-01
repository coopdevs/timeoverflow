module Persister
  class PostPersister
    attr_accessor :post

    def initialize(post)
      @post = post
    end

    def save
      post.save
    end

    def update_attributes(params)
      post.update_attributes(params)
    end
  end
end
