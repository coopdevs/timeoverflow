module GlyphHelper
  GLYPHS = {
    "offer" => "hand-up",
    "inquiry" => "bell",
    "user" => "user",
    "tag" => "tag",
    "category" => "folder-open",
    "organization" => "tower"
  }

  def glyph(kind, title=nil)
    kind = kind.to_s.underscore
    content_tag :span, "",
                class: "glyphicon glyphicon-#{glyph_name(kind)}",
                title: title
  end

  private

  def glyph_name(kind)
    GLYPHS.fetch kind, kind.dasherize
  end
end
