require "spec_helper"

describe Event do
  let(:post) { Fabricate(:post) }
  let(:member) { Fabricate(:member) }
  let(:event) { Event.new action: 'create' }

  describe '#resource_presence validation' do
    context 'has no resources' do
      it { expect(event).to_not be_valid }
    end

    context 'has one resource' do
      before { event.post = post }

      it { expect(event).to be_valid }
    end

    context 'has two resources' do
      before { event.post = post; event.member = member }

      it { expect(event).to_not be_valid }
    end
  end
end
