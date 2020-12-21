RSpec.describe Persister::PostPersister do
  let(:organization) { Fabricate(:organization) }
  let(:user) { Fabricate(:user) }
  let(:category) { Fabricate(:category) }
  let(:post) do
    Fabricate.build(
      :offer,
      organization: organization,
      user: user,
      category: category,
      title: 'Title'
    )
  end
  let(:persister) { ::Persister::PostPersister.new(post) }
  let(:event) { Fabricate.build(:event, id: 27) }

  describe '#save' do
    it 'saves the post' do
      persister.save

      expect(post).to be_persisted
    end

    it 'creates an event' do
      expect(::Event).to receive(:create!).with(action: :created, post: post).and_return(event)

      persister.save
    end

    context 'background job' do
      before do
        allow(::Event).to receive(:create!).and_return(event)
      end

      it 'enqueues a CreatePushNotificationsJob background job' do
        expect {
          persister.save
        }.to enqueue_job(CreatePushNotificationsJob).with(event_id: 27)
      end
    end
  end

  describe '#update_attributes' do
    it 'updates the resource attributes' do
      persister.update_attributes(title: 'New title')

      expect(post.title).to eq('New title')
    end

    it 'creates an event' do
      expect(::Event).to receive(:create!).with(action: :updated, post: post).and_return(event)

      persister.update_attributes(title: 'New title')
    end

    context 'background job' do
      before do
        allow(::Event).to receive(:create!).and_return(event)
      end

      it 'enqueues a CreatePushNotificationsJob background job' do
        expect {
          persister.update_attributes(title: 'New title')
        }.to enqueue_job(CreatePushNotificationsJob).with(event_id: 27)
      end
    end
  end
end
