module ApplicationHelper


  module CdnHelper


    PATHS = {
      googleapis: "//ajax.googleapis.com/ajax/libs",
      cloudflare: "//cdnjs.cloudflare.com/ajax/libs",
      netdna: "//netdna.bootstrapcdn.com"
    }

    LIBS = {
      jquery: :googleapis,
      angularjs: :googleapis,
      jqueryui: :googleapis,
      :"angular-strap" => :cloudflare,
      :"bootstrap-datepicker" => :cloudflare,
      :"lodash.js" => :cloudflare,
      select2: :cloudflare,
      :"twitter-bootstrap" => :netdna,
      :"font-awesome" => :netdna
    }

    def cdn(library, version, resource, *rest)
      base = PATHS[LIBS[library]]
      path = "#{base}/#{library}/#{version}/#{resource}"
      helper = case File.extname path
      when ".js"
        method :javascript_include_tag
      else
        method :stylesheet_link_tag
      end
      (helper.call path, *rest).html_safe
    end
  end

  include CdnHelper

end
