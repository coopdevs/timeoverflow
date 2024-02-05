class AddOrganizationToPost < ActiveRecord::Migration
  def up
    add_reference :posts, :organization, index: true
    Post.reset_column_information
    Post.all.each do |post|
      if post.user
        org = post.user.organizations.pluck(:id).first
        puts "Assigning #{post} to org #{org}".yellow
        post.update_column :organization_id, org
      end
    end
  end
  def down
    remove_reference :posts, :organization, index: true
  end
end
