require "spec_helper"

RSpec.describe Organization do
  let(:organization) { Fabricate(:organization) }

  describe '#display_id' do
    subject { organization.display_id(destination_accountable) }

    context 'when the destination_accountable is an organization' do
      let(:destination_accountable) { Fabricate(:organization) }
      it { is_expected.to eq(organization.account.accountable_id) }
    end

    context 'when the destination_accountable is not an organization' do
      let(:destination_accountable) { Fabricate(:member) }
      it { is_expected.to eq('') }
    end
  end

  describe 'ensure_url validation' do
    it "without http & https" do
      organization.web = "www.casa.com"
      expect(organization).to be_valid
      expect(organization.web).to eq "http://www.casa.com"
    end

    it "with http" do
      organization.web = "http://www.casa.com"
      expect(organization).to be_valid
      expect(organization.web).to eq "http://www.casa.com"
    end

    it "with https" do
      organization.web = "https://www.casa.com"
      expect(organization).to be_valid
      expect(organization.web).to eq "https://www.casa.com"
    end

    it "with blank value" do
      organization.web = ""
      expect(organization).to be_valid
      expect(organization.web).to eq ""
    end

    it "with nil value" do
      organization.web = nil
      expect(organization).to be_valid
      expect(organization.web).to eq nil
    end

    it "with an invalid" do
      organization.web = "la casa"
      expect(organization).not_to be_valid
      expect(organization.web).to eq "la casa"
      expect(organization.errors.size).to eq 1
    end
  end

  it 'name is mandatory' do
    organization.name = nil
    organization.save
    expect(organization.errors[:name]).to include(I18n.t('errors.messages.blank'))
  end
end
