ActiveAdmin.register User do
  action_item :upload_csv, only: :index do
    link_to I18n.t("active_admin.users.upload_from_csv"), action: "upload_csv"
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, method: :post do
    errors = UserImporter.call(params[:dump][:organization_id], params[:dump][:file])
    flash[:error] = errors.join("<br/>").html_safe if errors.present?

    redirect_to action: :index
  end

  index do
    column do |user|
      link_to image_tag(avatar_url(user, 24)), admin_user_path(user)
    end
    column :username
    column :email
    column :organizations do |u|
      u.organizations.map(&:to_s).join(", ")
    end
    actions
  end

  filter :organizations
  filter :email
  filter :username
  filter :phone
  filter :postcode

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :username
      f.input :email
      f.input :phone
      f.input :postcode
      f.input :gender, as: :select, collection: User::GENDERS
    end
    f.inputs "Memberships" do
      f.has_many :members do |m|
        m.input :organization, collection: Organization.order(id: :asc).pluck(:name, :id)
        m.input :active
        m.input :manager
      end
    end
    f.actions
  end

  show do |u|
    columns do
      column do
        attributes_table *default_attribute_table_rows
      end
      column do
        panel "Avatar" do
          image_tag avatar_url(u, 160)
        end
        panel "Memberships" do
          table_for user.members do
            column :organization
            column :active do |member|
              "✔" if member.active
            end
            column :manager do |member|
              "✔" if member.manager
            end
            column :entry_date
            column :member_uid
          end
        end
      end
    end
  end

  permit_params :username, :email, :phone, :postcode, :gender,
    members_attributes: [:organization_id, :active, :manager]
end
