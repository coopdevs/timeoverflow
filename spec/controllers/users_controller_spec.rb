require 'spec_helper'

describe UsersController do
  let (:test_organization) { Fabricate(:organization)}
  let (:member_admin) { Fabricate(:member, organization: test_organization, manager: true)}
  let (:member) { Fabricate(:member, organization: test_organization)}
  let! (:user) { member.user }
  let! (:admin_user) { member_admin.user}
  include_context "stub browser locale"
  before { set_browser_locale('ca') }

  describe "GET #index" do
    context "with an normal logged user" do
      it "populates and array of users" do
        login(member.user)

        get 'index'
        expect(assigns(:users)).to eq([user,admin_user])
      end
    end
    context "with an admin logged user" do
      it "populates and array of users" do
        login(member_admin.user)

        get 'index'
        expect(assigns(:users)).to eq([user,admin_user])
      end
    end
  end


  describe "GET #show" do
    context "with valid params" do
      context "with a normal logged user" do
        it "assigns the requested user to @user" do
          login(member.user)

          get 'show', id: user.id
          expect(assigns(:user)).to eq(user)
        end
      end
      context "with an admin logged user" do
        it "assigns the requested user to @user" do
          login(member_admin.user)

          get 'show', id: user.id
          expect(assigns(:user)).to eq(user)
        end
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      subject {post 'create', user: Fabricate.to_params(:user)}

      context "with a normal logged user" do
        it "does not create a new user" do
          login(member.user)

          # TODO:
          # Expect exception...
          #
          expect {
            post 'create', user: Fabricate.to_params(:user)
          }.to change(User,:count).by(0)
        end
      end

      context "with an admin logged user" do
        it "creates a new user" do
          login(member_admin.user)

          expect {
            subject
          }.to change(User,:count).by(1)

          subject.should redirect_to('/members')

        end
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      context "with a logged" do

        context "normal user" do
          it "located the requested @user" do
            login(member.user)

            put 'update', id: user.id, user: Fabricate.to_params(:user)
            expect(assigns(:user)).to eq(user)
          end

          #
          # TODO RAISE EXCEPTION
          #
          it "changes @user's attributes" do
            login(member.user)

            put 'update', id: user.id, user: Fabricate.to_params(:user, username: user.username, email: user.email, phone:'1234', alt_phone: "4321")

            user.reload
            expect(user.phone).not_to eq("1234")
            expect(user.alt_phone).not_to eq("4321")
          end
        end

        context "admin user" do
          it "located the requested @user" do
            login(member_admin.user)

            put 'update', id: user.id, user: Fabricate.to_params(:user)
            expect(assigns(:user)).to eq(user)
          end

          it "changes @user's attributes" do
            login(member_admin.user)

            put 'update', id: user.id, user: Fabricate.to_params(:user, username: user.username, email: user.email, phone:'1234', alt_phone: "4321")

            user.reload
            expect(user.phone).to eq("1234")
            expect(user.alt_phone).to eq("4321")
          end
        end
      end
    end

    context "with invalid params" do
      context "with a logged admin user" do
        it "does not change @user's attributes" do
          login(member_admin.user)

          put :update, id: user.id, user: Fabricate.to_params(:user, username: nil, email: nil, phone: "1234", alt_phone: "4321")

          expect(user.phone).not_to eq("1234")
          expect(user.alt_phone).not_to eq("4321")
        end
      end
    end
  end

end
