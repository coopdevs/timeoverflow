class OrganizationNotifierService
  def initialize(organization)
    @organization = organization
  end 

  def send_recent_posts_to_online_members #Enviar correo de prueba
    OrganizationNotifier.recent_posts
  end

#   def send_to_all_organizations
#      Organization.all.each do |org|
#      OrganizationNotifierService.new(organization: org).send_recent_posts_to_online_members
#    end
end