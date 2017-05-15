require 'spec_helper'

describe TransferCreator do
  describe '#create!' do
  	let(:jordi_member) { Fabricate(:member) }
  	let(:organization) { member.organization }
  	let(:paco_member) { Fabricate(:member, organization: organization) }
  	let(:jordi) { jordi_member.user }
  	let(:paco) { paco_member.user }
  	let(:amount) { 3 }
  	let(:post) { double(Post, id: 666) }
  	
  	subject do
  		described_class.new(
  			source: jordi,
      	destination: paco,
      	amount: amount,
      	reason: reason,
      	post_id: post.id
      ).create!
  	end

  	it 'Creates a new Transfer' do
  		expect(subject).to be true
  	end
  end
end