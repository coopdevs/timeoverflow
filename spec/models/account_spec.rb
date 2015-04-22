require 'spec_helper'

describe Account do
  let(:member) { Fabricate(:member) }
  let(:organization) { member.organization }
  let(:user) { member.user }

  specify "member has an account" do
    expect(member.account).not_to be_nil
  end

  specify "organization has an account" do
    expect(organization.account).not_to be_nil
  end

  specify "member's account belongs to organization" do
    expect(member.account.organization).to eq organization
  end

  specify "organization's account belongs to organization" do
    expect(organization.account.organization).to eq organization
  end

  specify "after create (member)" do
    member.account.destroy
    member.reload
    expect(member.account).to be_nil
    member.create_account
    expect(member.account).not_to be_nil
    expect(member.account.organization).to eq organization
  end

  specify "after create (member)" do
    organization.account.destroy
    organization.reload
    expect(organization.account).to be_nil
    organization.create_account
    expect(organization.account).not_to be_nil
    expect(organization.account.organization).to eq organization
  end

end
