require "spec_helper"

describe User do
  it { is_expected.to have_many :members }
  it { is_expected.to accept_nested_attributes_for :members }
  it { is_expected.to have_many :organizations }
  it { is_expected.to have_many :accounts }
  it { is_expected.to have_many :movements }

  it { is_expected.to have_many :posts }
  it { is_expected.to have_many :inquiries }
  it { is_expected.to have_many :offers }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to allow_value("my@email.com").for(:email) }
  it { is_expected.to_not allow_value("no @ here").for(:email) }

  it { is_expected.to validate_presence_of :username }

  describe "#setup_and_save_user" do
    it "sets a fake email before attempting to save user" do
      user = Fabricate.build(:user, email: "")

      expect(user.save).to eq(false)
      expect(user.setup_and_save_user).to eq(true)
    end
  end

  describe "#tune_after_persisted" do
    it "adds a user to an organization" do
      user = Fabricate(:user)
      organization = Fabricate(:organization)

      expect(user.tune_after_persisted(organization)).to eq(true)
    end
  end

  describe "#add_to_organization" do
    it "adds a user to an organization" do
      organization = Fabricate(:organization)
      user = Fabricate(:user)
      user.add_to_organization(organization)

      expect(user.organizations).to include(organization)
    end
  end

  describe "#member" do
    it "returns the user member of an organization" do
      user = Fabricate(:user)
      member = Fabricate(:member, user: user)
      organization = member.organization

      expect(user.member(organization)).to eq(member)
    end
  end

  describe ".actives" do
    skip "should list users with active members" do
      # The join at User.actives is failing
      user_w_inactive = Fabricate(:user)
      user_w_active = Fabricate(:user)
      inactive_member = Fabricate(:member, user: user_w_inactive, active: false)
      active_member = Fabricate(:member, user: user_w_active, active: true)

      expect(User.actives).to_not include(inactive_member.user)
      expect(User.actives).to include(active_member.user)
    end
  end

  describe "#active?" do
    it "returns true if a user is an active member of an organization" do
      user = Fabricate(:user)
      active_member = Fabricate(:member, user: user, active: true)
      organization = active_member.organization

      expect(user.active?(organization)).to eq(true)
    end

    it "returns false if a user is not an active member of an organization" do
      user = Fabricate(:user)
      inactive_member = Fabricate(:member, user: user, active: false)
      organization = inactive_member.organization

      expect(user.active?(organization)).to eq(false)
    end
  end

  describe "#has_valid_email?" do
    it "returns true if email does not contain example.com" do
      user1 = Fabricate.build(:user, email: "email@false.com")
      user2 = Fabricate.build(:user, email: "even_invalid")

      expect(user1.has_valid_email?).to eq(true)
      expect(user2.has_valid_email?).to eq(true)
    end

    it "returns false if email does not contain example.com" do
      user = Fabricate.build(:user, email: "email@example.com")
      expect(user.has_valid_email?).to eq(false)
    end
  end

  describe "#online_active" do
    it "should list users who have signed in sometime" do
      never_signed_in = Fabricate(:user)
      signed_in_once = Fabricate(:user, sign_in_count: 1)

      expect(User.online_active).not_to include(never_signed_in)
      expect(User.online_active).to include(signed_in_once)
    end
  end

  describe "#admins?" do
    it "should be true when a user admins an organization" do
      member = Fabricate(:member, manager: true)
      expect(member.user.admins?(member.organization)).to eq(true)
    end

    it "should be false when a user does not admin an organization" do
      member = Fabricate(:member, manager: false)
      expect(member.user.admins?(member.organization)).to eq(false)
    end
  end

  it "should return username when used as a string" do
    user = Fabricate(:user)
    expect("#{user}").to eq(user.username)
  end

  it "#superadmin?" do
    user = Fabricate(:user, email: ADMINS.sample)
    expect(user.superadmin?).to eq(true)
  end
end
