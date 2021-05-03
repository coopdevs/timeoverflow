RSpec.describe CategoriesHelper do
  before(:all) do
    Fabricate(:category, name_translations: { es: "Foo" })
    Fabricate(:category, name_translations: { es: "Bar" })
  end

  describe "#categories_for_select" do
    it "returns array [name, id] pairs with all categories (alpha sorted)" do
      expect(helper.categories_for_select.to_s).to match(/Bar.*\d.*Foo.*\d/)
    end
  end
end
