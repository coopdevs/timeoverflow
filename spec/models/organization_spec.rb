require 'spec_helper'

describe Organization do
  it "1:  without http & https" do
  	org = Organization.new
  	org.web = "www.casa.com"
  	expect(org.ensure_url).to eq "http://www.casa.com"
  end
  it "2: with http" do
  org = Organization.new
  	org.web = "http://www.casa.com"
  	expect(org.ensure_url).to eq "http://www.casa.com"
  end
  it "3: with https" do
  	org = Organization.new
  	org.web = "https://www.casa.com"
  	expect(org.ensure_url).to eq "https://www.casa.com"
  end
  it "3: blank" do
  	org = Organization.new
  	org.web = ""
  	expect(org.ensure_url).to eq ""
  end
  it "4: no url" do
  	org = Organization.new
  	org.web = "la casa"
  	expect(org.ensure_url).to eq "la casa"
  end
end
