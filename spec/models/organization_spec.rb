require 'spec_helper'

describe Organization do
	it "1:  without http & https" do
		org = Organization.new
		org.web = "www.casa.com"
		org.ensure_url
		expect(org.web).to eq "http://www.casa.com"
	end
	it "2: with http" do
		org = Organization.new
		org.web = "http://www.casa.com"
		org.ensure_url
		expect(org.web).to eq "http://www.casa.com"
	end
		it "3: with https" do
		org = Organization.new
		org.web = "https://www.casa.com"
		org.ensure_url
		expect(org.web).to eq "https://www.casa.com"
	end
	it "4: blank" do
		org = Organization.new
		org.web = ""
		org.ensure_url
		expect(org.web).to eq ""
	end
	it "5: nil" do
		org = Organization.new
		org.web = ""
		org.ensure_url
		expect(org.web).to eq ""
	end
	it "6: no url" do
		org = Organization.new
		org.web = "la casa"
		org.ensure_url
		expect(org.web).to eq "la casa"
		expect(org.errors.size).to eq 1

	end
end
