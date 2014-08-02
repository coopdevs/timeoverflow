class OffersController < PostsController

  def dashboard
    get_collection_ivar || begin
      offers_hash = Hash.new
      Category.all.each do |category|
        offers = current_organization.posts.where(type: "offer".capitalize.constantize, category_id: category.id).page(1).per(5)
        offers_hash[category] = offers if offers.any?
      end
      set_collection_ivar(offers_hash)
    end
  end

end
