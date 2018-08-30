require 'spec_helper'

RSpec.describe Account do
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

  describe '#update_balance' do
    let(:account) { member.account }

    context 'when the balance did not change since last balance update' do
      before do
        account.movements << Movement.new(amount: 5)
        account.save
      end

      it 'updates the account balance' do
        # a callback in Movement already called #update_balance after creating
        # the movement above
        account.update_balance
        expect(account.balance).to eq(5)
      end

      it 'does not flag the account' do
        # a callback in Movement already called #update_balance after creating
        # the movement above
        account.update_balance
        expect(account.flagged).to be_falsy
      end
    end

    context 'when the balance changed since last balance update' do
      context 'and the new balance falls within the limits allowed' do
        before do
          account.max_allowed_balance = 100
          account.min_allowed_balance = 0

          account.movements << Movement.new(amount: 5)
          account.save
        end

        it 'updates the account balance' do
          # a callback in Movement calls #update_balance after creating the
          # movement above
          expect(account.balance).to eq(5)
        end

        it 'does not flag the account' do
          # a callback in Movement calls #update_balance after creating the
          # movement above
          expect(account.flagged).to be_falsy
        end
      end

      context 'and the new balance does not fall within the limits allowed' do
        before do
          account.max_allowed_balance = 0
          account.min_allowed_balance = 0

          account.movements << Movement.new(amount: 5)
          account.save
        end

        it 'does not flag the account' do
          # a callback in Movement calls #update_balance after creating the
          # movement above
          expect(account.flagged).to be_truthy
        end
      end
    end
  end
end
