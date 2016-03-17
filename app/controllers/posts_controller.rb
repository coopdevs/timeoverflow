class PostsController <  ApplicationController
  has_scope :by_category, as: :cat
  has_scope :tagged_with, as: :tag
  has_scope :by_organization, as: :org

  def index
    if (query = params[:q]).present?
      # match query term on fields
      must = [ { multi_match: {
          query: query.to_s,
          type: "phrase_prefix",
          fields: ["title^2", "description", "tags^2"]
        } } ]
      if current_organization.present?
        # filter by organization
        must << { term: { organization_id: { value: current_organization.id } } }
      end
      posts = model.__elasticsearch__.search(
        query: {
          bool: {
            must: must
          }
        }
      ).page(params[:page]).per(25).records
    else
      posts = model.active.of_active_members
      if current_organization.present?
        posts = posts.merge(current_organization.posts)
      end
      posts = apply_scopes(posts).page(params[:page]).per(25)
    end
    instance_variable_set("@#{resources}", posts)
  end

  def new
    post = model.new
    post.user = current_user
    instance_variable_set("@#{resource}", post)
  end

  def create
    post = model.new(post_params)
    post.organization = current_organization
    if post.save
      redirect_to send("#{resource}_path", post)
    else
      instance_variable_set("@#{resource}", post)
      render action: :new
    end
  end

  def edit
    post = current_organization.posts.find params[:id]
    instance_variable_set("@#{resource}", post)
  end

  def show
    scope = if current_user.present?
              current_organization.posts.active.of_active_members
            else
              model.all.active.of_active_members
            end
    post = scope.find params[:id]
    instance_variable_set("@#{resource}", post)
  end

  def update
    post = current_organization.posts.find params[:id]
    authorize post
    instance_variable_set("@#{resource}", post)
    if post.update_attributes(post_params)
      redirect_to post
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_organization.posts.find params[:id]
    authorize post
    redirect_to send("#{resources}_path") if post.update!(active: false)
  end

  private

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
    permitted_fields = [:description, :end_on, :global, :joinable, :permanent,
                        :start_on, :title, :category_id, :user_id,
                        :publisher_id, :active, tag_list: []]

    params.fetch(resource, {}).permit(*permitted_fields).tap do |p|
      set_user_id(p)
    end
  end
end
