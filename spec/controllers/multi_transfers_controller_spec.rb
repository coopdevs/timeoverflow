RSpec.describe MultiTransfersController, type: :controller do
  let(:organization) { Fabricate(:organization) }
  let(:admin) { Fabricate(:member, organization: organization, manager: true) }
  let(:member) { Fabricate(:member, organization: organization) }
  let(:another_member) { Fabricate(:member, organization: organization) }
  let(:yet_another_member) { Fabricate(:member) }
  let(:test_category) { Fabricate(:category) }
  let!(:offer) do
    Fabricate(:offer,
              user: member.user,
              organization: organization,
              category: test_category)
  end

  it 'creates one to many transfers' do
    expect do
      login(admin.user)

      get :step, params: { step: 1 }

      params = {}

      post :step, params: params.merge!(
        step: 2,
        type_of_transfer: :one_to_many
      )

      post :step, params: params.merge!(
        step: 3,
        from: [member.account].map(&:id)
      )

      post :step, params: params.merge!(
        step: 4,
        to: [another_member.account, yet_another_member.account].map(&:id)
      )

      post :step, params: params.merge!(
        step: 5,
        transfer: {amount: 3600, reason: 'because of reasons'}
      )

      post :create, params: params
    end.to change { Transfer.count }.by(2)
  end

  it 'creates many to one transfers' do
    expect do
      login(admin.user)

      get :step, params: { step: 1 }

      params = {}

      post :step, params: params.merge!(
        step: 2,
        type_of_transfer: :many_to_one
      )

      post :step, params: params.merge!(
        step: 3,
        to: [another_member.account, yet_another_member.account].map(&:id)
      )

      post :step, params: params.merge!(
        step: 4,
        from: [member.account].map(&:id)
      )

      post :step, params: params.merge!(
        step: 5,
        transfer: {amount: 3600, reason: 'because of reasons'}
      )

      post :create, params: params
    end.to change { Transfer.count }.by(2)
  end

  context 'when only one source and one target is selected' do
    it 'creates one to one transfers' do
      expect do
        login(admin.user)

        get :step, params: { step: 1 }

        params = {}

        post :step, params: params.merge!(
          step: 2,
          type_of_transfer: :many_to_one
        )

        post :step, params: params.merge!(
          step: 3,
          to: [member.account].map(&:id)
        )

        post :step, params: params.merge!(
          step: 4,
          from: [another_member.account].map(&:id)
        )

        post :step, params: params.merge!(
          step: 5,
          transfer: {amount: 3600, reason: 'because of reasons'}
        )

        post :create, params: params
      end.to change { Transfer.count }.by(1)
    end
  end

  context 'non admins' do
    it 'cannot access step route' do
      login(member.user)

      get :step, params: { step: 1 }

      expect(response).not_to have_http_status(:success)
    end

    it 'cannot access create route' do
      login(member.user)

      post :create

      expect(response).to redirect_to('/')
    end
  end
end

