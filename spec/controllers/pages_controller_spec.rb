RSpec.describe PagesController do
  describe '#show' do
    it 'renders the page successfully' do
      get :show, params: { page: :about }

      expect(response).to render_template(:about)
    end

    it 'returns a 404 if the page does not exist' do
      get :show, params: { page: :foo }

      expect(response.status).to eq(404)
    end
  end
end
