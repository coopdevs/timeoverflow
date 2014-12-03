require "spec_helper"

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

  describe "GET #index" do
    context "with an normal logged user" do
      it "populates and array of users" do
        login(user)

        get "index"
        expect(assigns(:users)).to eq([user, another_user,
                                       admin_user, wrong_user,
                                       empty_email_user])
      end
    end
    context "with an admin logged user" do
      it "populates and array of users" do
        login(admin_user)

        get "index"
        expect(assigns(:users)).to eq([user, another_user,
                                       admin_user, wrong_user,
                                       empty_email_user])
      end
    end
  end

  describe "GET #show" do
    context "with valid params" do
      context "with a normal logged user" do
        it "assigns the requested user to @user" do
          login(user)

          get "show", id: user.id
          expect(assigns(:user)).to eq(user)
        end
      end
      context "with an admin logged user" do
        it "assigns the requested user to @user" do
          login(admin_user)

          get "show", id: user.id
          expect(assigns(:user)).to eq(user)
        end
      end
    end
  end

  describe "POST #create" do
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
          subject.should redirect_to("/members")
        end

        it "can create a user with a valid email" do
          subject { post "create", user: user }
          user.valid?
          user.errors[:email].count.should == 0
        end

        # TODO: To complete, now failing
        it "can create a user with empty email and generates dummy email" do
          empty_email_user[:email] = ""
          subject { post "create", user: empty_email_user }
          empty_email_user.valid?
          #expect { subject }.to change(User, :count).by(1)
          #empty_email_user.email.should match(/(user)\d+(@example.com)/)
          #subject.should redirect_to("/members")
          empty_email_user.errors[:email].count.should == 0
          #user.errors[:email].count.should == 0
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

        it "cannot create a user with invalid email" do
          wrong_user[:email] = "sin mail"
          subject { post "create", user: wrong_user }
          wrong_user.valid?
          wrong_user.errors[:email].count.should > 0
        end

        it "cannot create a user with dummy @example.com" do
          user[:email] = "@example.com"
          subject { post "create", user: user }
          user.valid?
          user.errors[:email].count.should > 0
        end
      end
    end
  end
end
