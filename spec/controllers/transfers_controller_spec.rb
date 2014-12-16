require 'spec_helper'

describe TransfersController do
  let (:test_organization) { Fabricate(:organization)}
  let (:member_admin) { Fabricate(:member, organization: test_organization, manager: true)}
  let (:member_giver) { Fabricate(:member, organization: test_organization) }
  let (:member_taker) { Fabricate(:member, organization: test_organization) }
  include_context "stub browser locale"
  before { set_browser_locale('ca') }

  describe "POST #create" do
    before { login(user) }


    context "with valid params" do
      context "with an admin user logged" do

        let(:user) { member_admin.user }
        subject { post 'create', transfer: {source: member_giver.account.id, destination: member_taker.account.id, amount: 5} }

        it "creates a new Transfer" do
          expect {
            subject
          }.to change(Transfer, :count).by 1
        end

        it "creates two Movements" do
          expect {
            subject
          }.to change { Movement.count}.by 2
        end

        it "updates the balance of both accounts" do
          expect {
            subject
            member_giver.reload
          }.to change { member_giver.account.balance.to_i }.by -5

          expect {
            subject
            member_taker.reload
          }.to change { member_taker.account.balance.to_i }.by 5
        end
      end

      context "with a regular user logged" do

        let(:user) { member_giver.user }
        subject { post 'create', transfer: {destination: member_taker.account.id, amount: 5} }

        it "creates a new Transfer" do
          expect {
            subject
          }.to change(Transfer, :count).by 1
        end

        it "creates two Movements" do
          expect {
            subject
          }.to change { Movement.count}.by 2
        end

        it "updates the balance of both accounts" do
          expect {
            subject
            member_giver.reload
          }.to change { member_giver.account.balance.to_i }.by -5

          expect {
            subject
            member_taker.reload
          }.to change { member_taker.account.balance.to_i }.by 5
        end

        it "redirects to destination" do
          expect(subject).to redirect_to(member_taker.user)
        end
      end
    end

  end
end
