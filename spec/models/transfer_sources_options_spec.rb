require 'spec_helper'

RSpec.describe TransferSourcesOptions do
  let(:transfer_sources_options) do
    described_class.new(sources, destination_accountable)
  end

  describe '#to_a' do
    let(:organization) { Fabricate(:organization) }
    let(:member) do
      Fabricate(:member, organization: organization, member_uid: 2)
    end
    let(:newer_member) do
      Fabricate(:member, organization: organization, member_uid: 1)
    end

    let(:destination_accountable) { Fabricate(:organization) }

    let(:sources) do
      [organization.account, member.account, newer_member.account]
    end

    it 'returns an array of option tags order by the acccountable type and its member_uid' do
      expect(transfer_sources_options.to_a)
        .to eq(
          [
            [
              "#{newer_member.member_uid} #{newer_member.class} #{newer_member}",
              newer_member.account.id
            ],
            [
              "#{member.member_uid} #{member.class} #{member}",
              member.account.id
            ],
            [
              "#{organization.id} #{organization.class} #{organization}",
              organization.account.id
            ]
          ]
      )
    end
  end
end
