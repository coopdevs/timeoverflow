ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Organizations" do
          ul do
            Organization.last(5).map do |organization|
              li link_to(organization, admin_organization_path(organization))
            end
          end
        end
      end

      column do
        panel "Recent Users" do
          ul do
            User.last(5).map do |user|
              li link_to(user, admin_user_path(user))
            end
          end
        end
      end

      column do
        panel "Recent Posts" do
          ul do
            Post.last(5).map do |post|
              li link_to(post, admin_post_path(post))
            end
          end
        end
      end

      column do
        panel "Recent Petitions" do
          ul do
            Petition.last(5).map do |petition|
              li "#{petition.user} #{glyph(:arrow_right)} #{petition.organization}".html_safe
            end
          end
        end
      end
    end
  end
end
