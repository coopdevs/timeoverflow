class PostsController <  ApplicationController
  has_scope :by_category, as: :cat
  has_scope :tagged_with, as: :tag
  has_scope :by_organization, as: :org

  def index
    context = model.active.of_active_members

    if current_user.present? && current_organization.present?
      if params[:show_allied].present?
      allied_org_ids = current_organization.allied_organizations.pluck(:id)
      org_ids = [current_organization.id] + allied_org_ids
      context = context.by_organizations(org_ids)
      elsif !params[:org].present?
      context = context.by_organization(current_organization.id)
      end
    end

    posts = apply_scopes(context)
    posts = posts.search_by_query(params[:q]) if params[:q].present?
    posts = posts.page(params[:page]).per(25)

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

    persister = ::Persister::PostPersister.new(post)

    if persister.save
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
    post = Post.active.of_active_members.find(params[:id])
    update_current_organization!(post.organization)

    instance_variable_set("@#{resource}", post)
  end

  def update
    post = current_organization.posts.find params[:id]
    authorize post
    instance_variable_set("@#{resource}", post)

    persister = ::Persister::PostPersister.new(post)

    if persister.update(post_params)
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
      p.reverse_merge! user_id: current_user.id
    else
      p.merge! user_id: current_user.id
    end
  end

  def post_params
    permitted_fields = [:description, :end_on, :start_on, :title, :category_id,
                        :user_id, :is_group, :active, tag_list: []]

    params.fetch(resource, {}).permit(*permitted_fields).tap do |p|
      set_user_id(p)
    end
  end

  def update_current_organization!(organization)
    return unless current_user && current_user.active?(organization)

    session[:current_organization_id] = organization.id
    @current_organization = organization
  end
end
