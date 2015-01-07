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
            User.last(5).map do |u|
              li link_to(u, admin_user_path(u))
            end
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to ActiveAdmin."
        end
      end
    end
  end
end
