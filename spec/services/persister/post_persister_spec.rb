require 'spec_helper'

describe Persister::PostPersister do
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
  let(:persister) { ::Persister::PostPersister.new(post, organization) }

  describe '#save' do
    before { persister.save }

    it 'saves the post' do
      expect(post).to be_persisted
    end

    # TODO: write better expectation
    it 'creates an event' do
      expect(Event.where(post_id: post.id).first.action).to eq('created')
    end
  end

  describe '#update_attributes' do
    before { persister.update_attributes(title: 'New title') }

    it 'updates the resource attributes' do
      expect(post.title).to eq('New title')
    end

    # TODO: write better expectation
    it 'creates an event' do
      expect(Event.where(post_id: post.id).first.action).to eq('updated')
    end
  end
end
