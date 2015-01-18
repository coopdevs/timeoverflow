module GlyphHelper
  GLYPHS = {
    "offer" => "hand-up",
    "inquiry" => "bell",
    "user" => "user",
    "tag" => "tag",
    "category" => "folder-open",
    "organization" => "tower"
  }

  def glyph(kind)
    kind = kind.to_s.underscore
    content_tag :span, "",
                class: "glyphicon glyphicon-#{glyph_name(kind)}"
  end

  private

  def glyph_name(kind)
    GLYPHS.fetch kind, kind.dasherize
  end
end
