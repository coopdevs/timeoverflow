module PostsHelper
  # Returns the right path to index list depending on type of post
  #
  # TODO: doesn't Rails URL helpers already provide this?
  def get_index_path(post, hparams)
    klass = post.class
    hparams[:organization_id] = @organization.id

    case
    when klass == String
      post.eql?("offers") ? organization_offers_path(hparams) : organization_inquiries_path(hparams)
    else
      post.type.eql?("Offer") ? organization_offers_path(hparams) : organization_inquiries_path(hparams)
    end
  end
end
