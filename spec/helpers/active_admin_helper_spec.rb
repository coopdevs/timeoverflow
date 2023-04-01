RSpec.describe ActiveAdminHelper do
  describe '#render_translations' do
    it 'renders hash to HTML' do
      attr_with_translations = { en: 'hi', es: 'hola' }
      expect(helper.render_translations(attr_with_translations)).to eq("<strong>English: </strong><span>hi</span> | <strong>Español: </strong><span>hola</span>")
    end
  end
end
