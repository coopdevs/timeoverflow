module PostsHelper
  # Returns the right path to index list depending on type of post
  def get_index_path(post, hparams)
    klass = post.class

    case
    when klass == String
      post.eql?("offers") ? offers_path(hparams) : inquiries_path(hparams)
    else
      post.type.eql?("Offer") ? offers_path(hparams) : inquiries_path(hparams)
    end
  end
end
