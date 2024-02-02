RSpec.describe PushNotifications::EventNotifierFactory do
  describe "#build" do
    let(:user) { Fabricate.build(:user) }
    let(:organization) { Fabricate(:organization) }
    let(:factory) { described_class.new(event: event) }

    context "when the given Event is associated to a Post" do
      let(:post) { Fabricate(:post, organization: organization, user: user) }
      let(:event) { Fabricate.build(:event, post: post, action: :created) }

      it "returns a Post notifier" do
        notifier = instance_double(::PushNotifications::EventNotifier::Post)
        allow(::PushNotifications::EventNotifier::Post).to receive(:new).and_return(notifier)

        expect(factory.build).to be(notifier)
      end
    end

    context "when the given Event is associated to a resource not supported" do
      let(:event) { Fabricate.build(:event, action: :created) }

      it "raises an error" do
        expect do
          factory.build
        end.to raise_error("The resource associated to the Event is not supported")
      end
    end
  end
end
