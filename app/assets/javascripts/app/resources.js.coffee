@APP.factory "Category", [ "$resource",
($resource) ->
  Category = $resource "/categories/:id", {},
    query:  method: "GET", isArray: true
    update: method: "PUT"
  Category.identityMap = {}
  Category::addToIdentityMap = ->
    Category.identityMap[@id] = this
  Category::toData = ->
    name: @name
    parent_id: @parent_id
  Category.property "parent"
    get: -> @_parent ?= if @parent_id then Category.identityMap[@parent_id] else null
  Category.property "fqn",
    get: -> @_fqn ?= if @parent then "#{@parent.fqn} > #{@name}" else @name
  # console.log Category, Category.prototype, Category.identityMap
  Category
]

@APP.factory "User", [ "$resource", "Organization",
($resource, Organization) ->
  User = $resource "/users/:id", {},
    query:  method: "GET", isArray: true
    update: method: "PUT"
  User.identityMap = {}
  User::name = ->
    "#{@username} <#{@email}>"
  User::addToIdentityMap = ->
    User.identityMap[@id] = this
  User.property "organization"
    get: -> @_organization ?= if @organization_id then Organization.identityMap[@organization_id] else null
  User::toData = ->
    username: @username
    email: @email
    category_ids: @category_ids
    date_of_birth: @date_of_birth
    identity_document: @identity_document
    phone: @phone
    alt_phone: @alt_phone
    password: @password
    password_confirmation: @password_confirmation
    organization_id: @organization_id
    registration_number: @registration_number
    registration_date: @registration_date
    admin: @admin
    superadmin: @superadmin
  User.addToIdentityMap = (data) ->
    if data instanceof Array
      d.addToIdentityMap?() for d in data
    else
      data.addToIdentityMap?()

  User
]

@APP.factory "Organization", [ "$resource",
($resource) ->
  Organization = $resource "/organizations/:id", {},
    query:  method: "GET", isArray: true
    update: method: "PUT"
  Organization.identityMap = {}
  Organization::addToIdentityMap = ->
    Organization.identityMap[@id] = this
  Organization::toData = ->
    name: @name
  Organization
]


@APP.factory "CurrentUser", ["$resource",
($resource) ->
  $resource "/me"
]
