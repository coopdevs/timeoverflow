RSpec.describe MemberDecorator do
  let(:org) { Fabricate(:organization) }
  let(:member) { Fabricate(:member, organization: org) }
  let(:view_context) { ApplicationController.new.view_context }
  let(:decorator) { MemberDecorator.new(member, view_context) }

  describe '#row_css_class' do
    subject { decorator.row_css_class }

    context 'active member' do
      it { is_expected.to be_nil }
    end

    context 'inactive member' do
      before { member.update_attributes(active: false) }
      it { is_expected.to eq('bg-danger') }
    end
  end

  describe '#inactive_icon' do
    subject { decorator.inactive_icon }

    context 'active member' do
      it { is_expected.to be_nil }
    end

    context 'inactive member' do
      before { member.update_attributes(active: false) }
      it { is_expected.to match('icon') }
    end
  end

  describe '#link_to_self' do
    subject { decorator.link_to_self }
    it { is_expected.to match("members/#{member.user.id}")}
  end

  describe '#mail_to' do
    subject { decorator.mail_to }

    context 'with standard email' do
      let(:email) { 'foobar@gmail.com' }

      context 'unconfirmed' do
        before { member.user.update_attributes(unconfirmed_email: email) }
        it { is_expected.to include('mailto:foobar@gmail.com') }
      end

      context 'confirmed' do
        before { member.user.update_attributes(email: email) }
        it { is_expected.to include('mailto:foobar@gmail.com') }
      end
    end

    context 'with placeholder email' do
      let(:email) { 'foobar@example.com' }

      context 'unconfirmed' do
        before { member.user.update_attributes(unconfirmed_email: email) }
        it { is_expected.to be_nil }
      end

      context 'confirmed' do
        before { member.user.update_attributes(email: email) }
        it { is_expected.to be_nil }
      end
    end
  end

  describe '#avatar_img' do
    subject { decorator.avatar_img }
    it { is_expected.to match(/gravatar/)}
  end

  describe '#account_balance' do
    subject { decorator.account_balance }
    it { is_expected.to eq('&mdash;') }

    context 'with positive balance' do
      before { member.account.update_attribute(:balance, 3600) }
      it { is_expected.to eq('1:00') }
    end

    context 'with negative balance' do
      before { member.account.update_attribute(:balance, -7500) }
      it { is_expected.to eq('-2:05') }
    end
  end

  describe '#toggle_manager_member_path' do
    subject { decorator.toggle_manager_member_path }
    it { is_expected.to include("members/#{member.id}/toggle_manager")}
  end

  describe '#cancel_member_path' do
    subject { decorator.cancel_member_path }
    it { is_expected.to include("members/#{member.id}")}
  end

  describe '#toggle_active_member_path' do
    subject { decorator.toggle_active_member_path }
    it { is_expected.to include("members/#{member.id}/toggle_active")}
  end
end
