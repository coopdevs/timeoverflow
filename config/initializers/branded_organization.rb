DEFAULT_BRANDED_ORG_ID = 246

Rails.application.config.branded_organization_id = nil

unless Rails.env.test?
  Rails.application.config.branded_organization_id = (Redis.current.get('branded_organization_id') || DEFAULT_BRANDED_ORG_ID).to_i
end
