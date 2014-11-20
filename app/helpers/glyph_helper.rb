module GlyphHelper

  GLYPHS = Hash[
    "offer" => "hand-up",
    "inquiry" => "bell",
    "user" => "user",
    "tag" => "tag",
    "category" => "folder-open",
    "organization" => "tower"
  ]

  def glyph(kind)
    kind = kind.to_s.underscore
    content_tag :span, "", class: "glyphicon glyphicon-#{GLYPHS.fetch kind, kind.gsub("_", "-")}"
  end

end
