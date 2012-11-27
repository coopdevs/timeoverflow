@APP.factory "Category", ($resource) ->
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
    get: -> @_fqn ?= if @parent then @parent.fqn + ' > ' + @name else @name
  # console.log Category, Category.prototype, Category.identityMap
  Category


@APP.factory "User", ($resource) ->
  User = $resource "/users/:id", {},
    query:  method: "GET", isArray: true
    update: method: "PUT"
  User.identityMap = {}
  User::name = ->
    "#{@username} <#{@email}>"
  User::addToIdentityMap = ->
    User.identityMap[@id] = this
  User::toData = ->
    username: @username
    email: @email
    category_ids: @categories
    date_of_birth: @date_of_birth
    phone: @phone
    alt_phone: @alt_phone
    password: @password
    password_confirmation: @password_confirmation
  # console.log User, User.prototype, User.identityMap
  User
