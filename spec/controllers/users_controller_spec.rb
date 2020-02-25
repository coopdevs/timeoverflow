require "spec_helper"

RSpec.describe UsersController do
  let(:test_organization) { Fabricate(:organization) }
  let(:member_admin) do
    Fabricate(:member,
              organization: test_organization,
              manager: true)
  end
  let(:member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
  end
  let(:another_member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
  end
  let(:wrong_email_member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
  end
  let(:empty_email_member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
  end

  let!(:user) { member.user }
  let!(:another_user) { another_member.user }
  let!(:admin_user) { member_admin.user }
  let!(:wrong_user) { wrong_email_member.user }
  let!(:empty_email_user) { empty_email_member.user }

  describe "GET #index" do
    before { login(user) }

    it 'sorts the users by their last_sign_in_at desc by default' do
      member.user.update_column(:last_sign_in_at, DateTime.now)
      another_member.user.update_column(:last_sign_in_at, nil)

      get :index

      expect(assigns(:members).first).to eq(member)
      expect(assigns(:members).last).to eq(another_member)
    end

    it 'allows to sort by member_uid' do
      member.increment!(:member_uid, Member.maximum(:member_uid) + 1)

      get :index, params: { q: { s: "member_uid desc" } }

      expect(assigns(:members).first).to eq(member)
    end

    context 'when a user has many memberships' do
      let!(:member_in_another_organization) { Fabricate(:member, user: user) }

      before do
        member.account.update_attribute(
          :balance,
          Time.parse('13:33').seconds_since_midnight
        )
      end

      it 'gets her membership in the current organization' do
        get :index

        expect(assigns(:members))
          .to eq([member, another_member, member_admin, wrong_email_member, empty_email_member])
      end

      it 'shows data for her membership in the current organization' do
        get :index
        expect(response.body).to include("13:33")
      end
    end

    context "with an normal logged user" do
      it "populates and array of users" do
        get "index"

        expect(assigns(:members).map(&:user))
          .to eq([user, another_user, admin_user, wrong_user, empty_email_user])
      end
    end

    context "with an admin logged user" do
      it "populates and array of users" do
        login(admin_user)

        get "index"

        expect(assigns(:members).map(&:user))
          .to eq([user, another_user, admin_user, wrong_user, empty_email_user])
      end
    end

    context 'when searching' do
      it 'allows to search by member_uid' do
        user = Fabricate(:user, username: 'foo', email: 'foo@email.com')
        member = Fabricate(:member, user: user, organization: test_organization, member_uid: 1000)

        get :index, params: { q: { user_username_or_user_email_or_member_uid_search_contains: 1000 } }

        expect(assigns(:members)).to include(member)
      end
    end
  end

  describe "GET #manage" do
    before { login(user) }

    it 'sorts the users by their member_uid asc by default' do
      member.increment!(:member_uid, Member.maximum(:member_uid) + 1)

      get :manage

      expect(assigns(:members).last).to eq(member)
    end

    context 'when sorting by balance' do
      before do
        member_admin.account.update_attribute(:balance, 3600)
      end

      context 'desc' do
        let(:direction) { 'desc' }

        it 'orders the rows by their balance' do
          get :manage, params: { q: { s: "account_balance #{direction}" } }

          expect(assigns(:members).pluck(:user_id).first).to eq(admin_user.id)
        end
      end

      context 'asc' do
        let(:direction) { 'asc' }

        it 'orders the rows by their balance' do
          get :manage, params: { q: { s: "account_balance #{direction}" } }

          expect(assigns(:members).pluck(:user_id).last).to eq(admin_user.id)
        end
      end
    end
  end

  describe "GET #show" do
    context "with valid params" do
      context "with a normal logged user" do
        before { login(another_user) }

        it "assigns the requested user to @user" do
          get "show", params: { id: user.id }
          expect(assigns(:user)).to eq(user)
        end

        it 'links to new_transfer_path for his individual offers' do
          offer = Fabricate(:offer, user: user, organization: test_organization)

          get "show", params: { id: user.id }
          expect(response.body).to include(
            "<a href=\"/transfers/new?destination_account_id=#{member.account.id}&amp;id=#{user.id}&amp;offer=#{offer.id}\">"
          )
        end
      end

      context "with an admin logged user" do
        before { login(admin_user) }

        it "assigns the requested user to @user" do
          get "show", params: { id: user.id }
          expect(assigns(:user)).to eq(user)
        end

        it 'links to new_transfer_path' do
          get "show", params: { id: user.id }
          expect(response.body).to include(
            "<a href=\"/transfers/new?destination_account_id=#{member.account.id}&amp;id=#{user.id}\">"
          )
        end

        it 'links to new_transfer_path for his individual offers' do
          offer = Fabricate(:offer, user: user, organization: test_organization)

          get "show", params: { id: user.id }
          expect(response.body).to include(
            "<a href=\"/transfers/new?destination_account_id=#{member.account.id}&amp;id=#{user.id}&amp;offer=#{offer.id}\">"
          )
        end
      end
    end
  end

  describe "POST #create" do
    context "with empty email" do

      subject do
        post "create", params: { user: Fabricate.to_params(:user,
                                       username: user.username + "2",
                                       email: "",
                                       phone: "1234",
                                       alt_phone: "4321") }
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
      subject { post "create", params: { user: Fabricate.to_params(:user) } }

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
          subject { post "create", params: { user: user } }
          user.valid?
          expect(user.errors[:email]).to be_empty
        end

        it "cannot create a user with invalid email" do
          wrong_user[:email] = "sin mail"
          subject { post "create", params: { user: wrong_user } }
          wrong_user.valid?
          expect(wrong_user.errors[:email]).not_to be_empty
        end

        it "cannot create a user with dummy @example.com" do
          user[:email] = "@example.com"
          subject { post "create", params: { user: user } }
          user.valid?
          expect(user.errors[:email]).not_to be_empty
        end

        it "cannot create a user with existing e-mail" do
          user[:email] = another_user[:email]
          subject { post "create", params: { user: user } }
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
            put "update", params: { id: user.id, user: Fabricate.to_params(:user) }
            expect(assigns(:user)).to eq(user)
          end

          it "changes @user's own attributes" do
            put "update", params: { id: user.id, user: Fabricate.to_params(:user,
                                          username: user.username,
                                          email: user.email,
                                          phone: "1234",
                                          alt_phone: "4321") }

            user.reload
            expect(user.phone).to eq("1234")
            expect(user.alt_phone).to eq("4321")
          end

          it "cannot change another user's attributes" do
            put "update", params: { id: another_user.id, user: Fabricate.to_params(:user,
                                          username: another_user.username,
                                          email: another_user.email,
                                          phone: "5678",
                                          alt_phone: "8765") }

            user.reload
            expect(user.phone).not_to eq("5678")
            expect(user.alt_phone).not_to eq("8765")
          end
        end

        context "admin user" do
          before { login(admin_user) }

          it "locates the requested @user" do
            put "update", params: { id: user.id, user: Fabricate.to_params(:user) }
            expect(assigns(:user)).to eq(user)
          end

          it "changes @user's attributes" do
            put "update", params: { id: user.id, user: Fabricate.to_params(:user,
                                          username: user.username,
                                          email: user.email,
                                          phone: "1234",
                                          alt_phone: "4321") }

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
          put :update, params: { id: user.id, user: Fabricate.to_params(:user,
                                        username: nil,
                                        email: nil,
                                        phone: "1234",
                                        alt_phone: "4321") }

          expect(user.phone).not_to eq("1234")
          expect(user.alt_phone).not_to eq("4321")
        end
      end
    end
  end
end
