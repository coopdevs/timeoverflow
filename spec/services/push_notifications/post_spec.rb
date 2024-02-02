RSpec.describe PushNotifications::Creator::Post do
  let(:user) { Fabricate(:user) }
  let!(:device_token) { Fabricate(:device_token, user: user, token: "aloha") }
  let(:organization) { Fabricate(:organization) }
  let(:post) { Fabricate(:post, organization: organization, user: user) }
  let(:event) { Fabricate.build(:event, post: post, action: :created) }
  let(:creator) { described_class.new(event: event) }

  before do
    organization.members.create(user: user)
  end

  describe "#create!" do
    context "integration" do
      it "creates as many PushNotification resources as needed" do
        expect { creator.create! }.to change { PushNotification.count }.by(1)
      end
    end

    context "unit" do
      let(:post) do
        Fabricate(
          :post,
          organization: organization,
          user: user,
          description: description
        )
      end

      before { allow(PushNotification).to receive(:create!) }

      context "when the post description is empty" do
        let(:description) { "" }

        it "creates a PushNotification with a default body" do
          creator.create!

          expect(PushNotification).
            to have_received(:create!).
            with(include(body: "No description"))
        end
      end

      context "when the post description is nil" do
        let(:description) { nil }

        it "creates a PushNotification with a default body" do
          creator.create!

          expect(PushNotification).
            to have_received(:create!).
            with(include(body: "No description"))
        end
      end

      context "when the post description is shorter than 20 chars" do
        let(:description) { "description" }

        it "creates a PushNotification with the post body" do
          creator.create!

          expect(PushNotification).
            to have_received(:create!).
            with(include(body: post.description))
        end
      end

      context "when the post description is larger than 20 chars" do
        let(:description) { "this is a very long description" }

        it "creates a PushNotification with the post body truncated" do
          creator.create!

          expect(PushNotification).
            to have_received(:create!).
            with(include(body: post.description.truncate(20)))
        end
      end
    end
  end
end
