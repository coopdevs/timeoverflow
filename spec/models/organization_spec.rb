require "spec_helper"

describe Organization do
  let(:org) { Organization.new name: "Banc del Temps dels Quatre Pins" }
  it "1:  without http & https" do
    org.web = "www.casa.com"
    expect(org).to be_valid
    expect(org.web).to eq "http://www.casa.com"
  end
  it "2: with http" do
    org.web = "http://www.casa.com"
    expect(org).to be_valid
    expect(org.web).to eq "http://www.casa.com"
  end
  it "3: with https" do
    org.web = "https://www.casa.com"
    expect(org).to be_valid
    expect(org.web).to eq "https://www.casa.com"
  end
  it "4: blank" do
    org.web = ""
    expect(org).to be_valid
    expect(org.web).to eq ""
  end
  it "5: nil" do
    org.web = ""
    expect(org).to be_valid
    expect(org.web).to eq ""
  end
  it "6: no url" do
    org.web = "la casa"
    expect(org).not_to be_valid
    expect(org.web).to eq "la casa"
    expect(org.errors.size).to eq 1
  end
end
