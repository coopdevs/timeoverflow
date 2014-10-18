class AddPublisherIdToPost < ActiveRecord::Migration
  def change
    add_reference :posts, :publisher, index: true
  end
end
