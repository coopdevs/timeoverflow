require 'spec_helper'

describe Persister::PostPersister do
  let(:organization) { Fabricate(:organization) }
  let(:user) { Fabricate(:user) }
  let(:category) { Fabricate(:category) }
  let(:post) { Fabricate(:post, organization: organization) }

  describe '#save' do
    it 'saves the post' do
      post = Offer.new(organization: organization, user: user, category: category, title: 'Title')
      persister = ::Persister::PostPersister.new(post)

      persister.save

      expect(post).to be_persisted
    end
  end

  describe '#update_attributes' do
    it 'updates the attributes' do
      persister = ::Persister::PostPersister.new(post)
      persister.update_attributes(title: 'New title')

      expect(post.title).to eq('New title')
    end
  end
end
