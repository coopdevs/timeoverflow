class PostsController <  ApplicationController # InheritedResources::Base
  respond_to :html, :js

  has_scope :by_category, as: :cat
  has_scope :fuzzy_and_tags, as: :q
  has_scope :tagged_with, as: :tag
  has_scope :by_organization, as: :org

  def index
    posts = apply_scopes(model).page(params[:page]).per(25)
    instance_variable_set("@#{resources}", posts)
  end

  def new
    post = model.new
    post.user = current_user
    instance_variable_set("@#{resource}", post)
  end

  def create
    post = model.new(post_params)
    post.user = current_user
    post.organization = current_organization
    redirect_to send("#{resource}_path", post) if post.save
  end

  def edit
    post = current_organization.posts.find params[:id]
    instance_variable_set("@#{resource}", post)
  end

  def show
    post = current_organization.posts.find params[:id]
    instance_variable_set("@#{resource}", post)
  end

  def update
    post = current_organization.posts.find params[:id]
    authorize post
    redirect_to post if post.update_attributes(post_params)
    instance_variable_set("@#{resource}", post)
  end

  def destroy
    post = current_organization.posts.find params[:id]
    authorize post
    redirect_to send("#{resources}_path") if post.destroy
  end

  private

  def model
    controller_name == "offers" ? Offer : Inquiry
  end

  def resource
    controller_name.singularize
  end

  def resources
    controller_name
  end

  def set_user_id(p)
    if current_user.manages?(current_organization)
      p.update publisher_id: current_user.id
      p.reverse_merge! user_id: current_user.id
    else
      p.update user_id: current_user.id
    end
  end

  def post_params
    permitted_fields = %i[description end_on global joinable permanent start_on
                          title category_id tag_list user_id publisher_id]

    params.fetch(resource, {}).permit(*permitted_fields).tap do |p|
      set_user_id(p)
    end
  end
end
