module OrganizationsHelper
  def filterable_organizations
    Organization.all.order(:name)
  end

  def allied_organizations
    return [] unless current_organization

    allied_org_ids = current_organization.accepted_alliances.map do |alliance|
      alliance.source_organization_id == current_organization.id ?
        alliance.target_organization_id : alliance.source_organization_id
    end

    organizations = Organization.where(id: allied_org_ids + [current_organization.id])
    organizations.order(:name)
  end

  def alliance_initiator?(alliance)
    alliance.source_organization_id == current_organization.id
  end

  def alliance_recipient(alliance)
    alliance_initiator?(alliance) ? alliance.target_organization : alliance.source_organization
  end
end
