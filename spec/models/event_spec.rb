require "spec_helper"

describe Event do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:action) }
    it { is_expected.to validate_inclusion_of(:action).in_array(::Event::ACTIONS) }

    describe '#resource_presence validation' do
      let(:post) { Fabricate(:post) }
      let(:member) { Fabricate(:member) }
      let(:event) { Event.new action: 'create' }

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

  describe 'Relations' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:member) }
    it { is_expected.to belong_to(:transfer) }

    it { is_expected.to have_db_column(:post_id) }
    it { is_expected.to have_db_column(:member_id) }
    it { is_expected.to have_db_column(:transfer_id) }
  end

  describe 'Indexes' do
    it { is_expected.to have_db_index(:post_id) }
    it { is_expected.to have_db_index(:member_id) }
    it { is_expected.to have_db_index(:transfer_id) }
  end
end
