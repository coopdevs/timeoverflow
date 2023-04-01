RSpec.describe ActiveAdminHelper do
  describe '#render_translations' do
    it 'renders all available translations for the given attribute' do
      attr_with_translations = { en: 'hi', es: 'hola' }
      expect(helper.render_translations(attr_with_translations)).to eq("<strong>English: </strong><span>hi</span> <strong>Español: </strong><span>hola</span>")
    end
  end
end
