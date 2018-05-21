require 'spec_helper'

describe GlyphHelper do
  describe 'glyph helper' do
    it 'renders an span with glyphicon classes' do
      expect(helper.glyph('foo')).to match(/<span class=\"glyphicon glyphicon-foo\"><\/span>/)
    end

    it 'special mappings' do
      sample = GlyphHelper::GLYPHS.to_a.sample[0]
      expect(helper.glyph(sample)).to match(GlyphHelper::GLYPHS[sample])
    end
  end
end