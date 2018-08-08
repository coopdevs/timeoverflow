module ApplicationHelper

  TEXT_SUCCESS = 'text-success'.freeze
  TEXT_DANGER = 'text-danger'.freeze

  # from gravatar
  def avatar_url(user, size = 32)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    gravatar_options = {
      set: "set1",
      gravatar: "hashed",
      size: "#{size}x#{size}",
      d: "identicon"
    }

    "https://www.gravatar.com/avatar/#{gravatar_id}.png?#{gravatar_options.to_param}"
  end

  def mdash
    raw "&mdash;"
  end

  def seconds_to_hm(seconds)
    sign = seconds <=> 0
    if sign.try :nonzero?
      minutes, _seconds = seconds.abs.divmod(60)
      hours, minutes = minutes.divmod(60)
      raw format("%s%d:%02d", ("-" if sign < 0), hours, minutes)
    else
      mdash
    end
  end

  def tnc_path
    document_path(Document.terms_and_conditions || 0, modal: true)
  end

  def show_error_messages!(resource)
    return "" if resource.errors.empty?

    messages = resource.errors.
               full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="alert alert-danger">
      <button type="button" class="close" data-dismiss="alert">x</button>
      <ul>
        #{messages}
      </ul>
    </div>
    HTML

    html.html_safe
  end

  # Use as <%= markdown content %> or <%= m content %>
  # Content can be nil, in that case
  # it will be the same as an empty string.
  def markdown(content)
    RDiscount.new(content || ''.freeze).to_html.html_safe
  end

  alias m markdown

  # Green or red CSS class depending on whether
  # positive or negative amount
  def green_red(amount)
    case amount <=> 0
    when -1 then TEXT_DANGER
    when 0 then nil
    when 1 then TEXT_SUCCESS
    end
  end

  def get_body_css_class(controller)
    classes = {
      'home' => 'landing-page',
      'sessions' => 'login-page',
      'pages' => 'pages',
      'unlocks' => 'unlocks-page',
      'passwords' => 'passwords-page',
      'confirmations' => 'confirmations-page'
    }

    "#{classes[controller]}"
  end

  def alert_class(alert)
    case alert
    when 'error', 'alert'
      'alert-danger'
    when 'notice'
      'alert-success'
    else
      'alert-info'
    end
  end
end
