# coding: utf-8

ActiveAdmin.register User do
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

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Admin Details" do
      f.input :username
      f.input :email
      f.input :gender, :as => :select, :collection => User::GENDERS
      f.input :identity_document
    end
    f.inputs "Members" do
      f.has_many :members do |m|
        m.input :organization
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

  permit_params *User.attribute_names, members_attributes: Member.attribute_names
end
