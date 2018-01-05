require "spec_helper"

describe Organization do
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

  it "1:  without http & https" do
    organization.web = "www.casa.com"
    expect(organization).to be_valid
    expect(organization.web).to eq "http://www.casa.com"
  end
  it "2: with http" do
    organization.web = "http://www.casa.com"
    expect(organization).to be_valid
    expect(organization.web).to eq "http://www.casa.com"
  end
  it "3: with https" do
    organization.web = "https://www.casa.com"
    expect(organization).to be_valid
    expect(organization.web).to eq "https://www.casa.com"
  end
  it "4: blank" do
    organization.web = ""
    expect(organization).to be_valid
    expect(organization.web).to eq ""
  end
  it "5: nil" do
    organization.web = ""
    expect(organization).to be_valid
    expect(organization.web).to eq ""
  end
  it "6: no url" do
    organization.web = "la casa"
    expect(organization).not_to be_valid
    expect(organization.web).to eq "la casa"
    expect(organization.errors.size).to eq 1
  end
end
