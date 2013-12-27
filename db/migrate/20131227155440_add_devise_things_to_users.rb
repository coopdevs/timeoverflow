class AddDeviseThingsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      ## Database authenticatable
      # t.string :email,              :null => false, :default => ''
      t.string :encrypted_password, :null => false, :default => ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      ## Lockable
      t.integer  :failed_attempts, :default => 0
      t.string   :unlock_token
      t.datetime :locked_at

      # Token authenticatable
      # t.string :authentication_token

      ## Invitable
      # t.string :invitation_token
    end
  end
end
