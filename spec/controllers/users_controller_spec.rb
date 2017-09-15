require 'spec_helper'

describe UsersController do
  let (:test_organization) { Fabricate(:organization) }
  let (:member_admin) do
    Fabricate(:member,
              organization: test_organization,
              manager: true)
  end
  let (:member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
  end
  let (:another_member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
  end
  let (:wrong_email_member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
  end
  let (:empty_email_member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
  end

  let! (:user) { member.user }
  let! (:another_user) { another_member.user }
  let! (:admin_user) { member_admin.user }
  let! (:wrong_user) { wrong_email_member.user }
  let! (:empty_email_user) { empty_email_member.user }

  include_context "stub browser locale"
  before { set_browser_locale("ca") }

  describe 'GET #show' do
    context 'when the user is the same user' do
      before { login(user) }

      it 'assigns user to @user' do
        get :show, id: user
        expect(assigns(:user)).to eq(user)
      end

      it 'renders a page with the user username' do
        get :show, id: user
        expect(response.body).to include(user.username)
      end

      it 'renders a page with the user avatar as link to Gravatar' do
        get :show, id: user
        expect(response.body).to include("<a href=\"https://www.gravatar.com\" target=\"_blank\">")
        expect(response.body).to include("<img style=\"margin: -8px auto\" src=\"https://www.gravatar.com/avatar/")
      end

      it 'renders a page with the user description' do
        get :show, id: user
        expect(response.body).to include(user.description)
      end

      it 'renders a page with a link to edit the user profile' do
        get :show, id: user
        expect(response.body).to include("<a href=\"/account/edit\"")
      end
    end

    context 'when the user is not the same' do
      before { login(user) }

      context 'and is not a member of the same organization' do
        let(:other_organization) { Fabricate(:organization) }
        let(:other_admin) do
          Fabricate(
            :member,
            organization: test_organization,
            manager: true
          )
        end
        let(:other_user) { other_admin.user }

        it 'redirects to root path' do
          get :show, id: other_user

          expect(response).to redirect_to(root_path)
        end

        it 'sets an error flash message' do
          get :show, id: other_user

          expect(flash[:error]).to match(/You are not authorized to perform this action./)
        end
      end

      context 'and is a member of the same organization' do
        context 'and is not an admin of the organization' do
          it 'redirects to root path' do
            get :show, id: another_user

            expect(response).to redirect_to(root_path)
          end

          it 'sets an error flash message' do
            get :show, id: another_user

            expect(flash[:error]).to match(/You are not authorized to perform this action./)
          end
        end

        context 'and is an admin of the organization' do
          before { login(admin_user) }

          it 'assigns user to @user' do
            get :show, id: user
            expect(assigns(:user)).to eq(user)
          end

          it 'renders a page with the user username' do
            get :show, id: user
            expect(response.body).to include(user.username)
          end

          it 'renders a page with the user avatar' do
            get :show, id: user
            expect(response.body).to include("<img style=\"margin: -8px auto\" src=\"https://www.gravatar.com/avatar/")
          end

          it 'renders a page with a link to give time to the user' do
            get :show, id: user
            expect(response.body).to include("<a href=\"/users/#{user.id}/give_time\">")
          end
        end
      end
    end
  end

  describe "POST #create" do
    context "with empty email" do

      subject do
        post "create",
             user: Fabricate.to_params(:user,
                                       username: user.username + "2",
                                       email: "",
                                       phone: "1234",
                                       alt_phone: "4321")
      end

      before { login(admin_user) }

      it "can create a user with empty email and generates dummy email" do

        expect { subject }.to change(User, :count).by(1)

        u = User.find_by(username: user.username + "2")
        u.valid?
        expect(u.email).to match(/(user)\d+(@example.com)/)
        expect(u.errors[:email]).to be_empty
        expect(subject).to redirect_to("/members")
      end
    end

    context "with valid params" do
      subject { post "create", user: Fabricate.to_params(:user) }

      context "with a normal logged user" do
        it "does not create a new user" do
          login(user)

          expect { subject }.to change(User, :count).by(0)
        end
      end

      context "with an admin logged user" do
        before { login(admin_user) }

        it "creates a new user" do
          expect { subject }.to change(User, :count).by(1)
          expect(subject).to redirect_to("/members")
        end

        it "can create a user with a valid email" do
          subject { post "create", user: user }
          user.valid?
          expect(user.errors[:email]).to be_empty
        end

        it "cannot create a user with invalid email" do
          wrong_user[:email] = "sin mail"
          subject { post "create", user: wrong_user }
          wrong_user.valid?
          expect(wrong_user.errors[:email]).not_to be_empty
        end

        it "cannot create a user with dummy @example.com" do
          user[:email] = "@example.com"
          subject { post "create", user: user }
          user.valid?
          expect(user.errors[:email]).not_to be_empty
        end

        it "cannot create a user with existing e-mail" do
          user[:email] = another_user[:email]
          subject { post "create", user: user }
          user.valid?
          expect(user.errors[:email]).not_to be_empty
        end

      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      context "with a logged" do
        context "normal user" do
          before { login(member.user) }
          it "locates the requested @user" do
            put "update", id: user.id, user: Fabricate.to_params(:user)
            expect(assigns(:user)).to eq(user)
          end

          it "changes @user's own attributes" do
            put "update",
                id: user.id,
                user: Fabricate.to_params(:user,
                                          username: user.username,
                                          email: user.email,
                                          phone: "1234",
                                          alt_phone: "4321")

            user.reload
            expect(user.phone).to eq("1234")
            expect(user.alt_phone).to eq("4321")
          end

          it "cannot change another user's attributes" do
            put "update",
                id: another_user.id,
                user: Fabricate.to_params(:user,
                                          username: another_user.username,
                                          email: another_user.email,
                                          phone: "5678",
                                          alt_phone: "8765")

            user.reload
            expect(user.phone).not_to eq("5678")
            expect(user.alt_phone).not_to eq("8765")
          end
        end

        context "admin user" do
          before { login(admin_user) }

          it "locates the requested @user" do
            put "update", id: user.id, user: Fabricate.to_params(:user)
            expect(assigns(:user)).to eq(user)
          end

          it "changes @user's attributes" do
            put "update",
                id: user.id,
                user: Fabricate.to_params(:user,
                                          username: user.username,
                                          email: user.email,
                                          phone: "1234",
                                          alt_phone: "4321")

            user.reload
            expect(user.phone).to eq("1234")
            expect(user.alt_phone).to eq("4321")
          end
        end
      end
    end

    context "with invalid params" do
      context "with a logged admin user" do
        before { login(admin_user) }

        it "does not change @user's attributes" do
          put :update,
              id: user.id,
              user: Fabricate.to_params(:user,
                                        username: nil,
                                        email: nil,
                                        phone: "1234",
                                        alt_phone: "4321")

          expect(user.phone).not_to eq("1234")
          expect(user.alt_phone).not_to eq("4321")
        end
      end
    end
  end
end
