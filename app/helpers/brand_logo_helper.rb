module BrandLogoHelper
  def render_brand_logo
    return unless should_render_logo?
    render 'application/brand_logo'
  end

  private

  def should_render_logo?
    current_organization&.id == branded_organization_id
  end

  def branded_organization_id
    Rails.application.config.branded_organization_id
  end
end
