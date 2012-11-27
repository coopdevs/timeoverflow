
@RootController = ["$scope", "$http", "$routeParams", "$location", "Category", "Organization",
($scope, $http, $routeParams, $location, Category, Organization) ->
  $scope.brand = "TimeOverflow"
  $scope.loadCategories = ->
    $scope.categories = Category.query {}, (data) ->
      c.addToIdentityMap() for c in data
  $scope.loadOrganizations = ->
    $scope.organizations = Organization.query {}, (data) ->
      c.addToIdentityMap() for c in data
      console.log Organization.identityMap
  $scope.loadCategories()
  $scope.loadOrganizations()
  $scope.$on "go", (ev, where) ->
    if where.path then $location.path where.path
    if where.search then $location.search where.search
  $scope.$on "loadCategories", (ev) -> $scope.loadCategories()
  $scope.$on "loadOrganizations", (ev) -> $scope.loadOrganizations()
]

# class Category
#   constructor: (attrs) -> angular.extend this, attrs
#   fqn: -> @_fqn ?= if @parent then @parent.fqn() + ' > ' + @name else @name



@CategoriesController = ["$scope", "$http", "$routeParams", "Category", ($scope, $http, $routeParams, Category) ->
  if $routeParams.id is "new"
    $scope.object = new Category()
  else if $routeParams.id
    $scope.object = Category.get id: $routeParams.id
  else
    $scope.object = null
  $scope.save = (obj) ->
    success = ->
      $scope.$emit "go", path: "/categories"
      $scope.$emit "loadCategories"
    failure = (data, headers) ->
      console.log "ERROR", data, headers()
      alert "error"
    if obj.id?
      Category.update {id: obj.id}, {category: obj.toData()}, success, failure
    else
      Category.save {category: obj.toData()}, success, failure
  $scope.formTitle = ->
    if $scope.object?.id then "Edit \"#{$scope.object.name}\"" else "New category"
]



@OrganizationsController = ["$scope", "$http", "$routeParams", "Organization",
($scope, $http, $routeParams, Organization) ->
  if $routeParams.id is "new"
    $scope.object = new Organization()
  else if $routeParams.id
    $scope.object = Organization.get id: $routeParams.id
  else
    $scope.object = null
  $scope.save = (obj) ->
    success = ->
      $scope.$emit "go", path: "/organizations"
      $scope.$emit "loadOrganizations"
    failure = (data, headers) ->
      console.log "ERROR", data, headers()
      alert "error"
    if obj.id?
      Organization.update {id: obj.id}, {organization: obj.toData()}, success, failure
    else
      Organization.save {organization: obj.toData()}, success, failure
  $scope.formTitle = ->
    if $scope.object?.id then "Edit \"#{$scope.object.name}\"" else "New organization"
]




@UsersController = ["$scope", "$http", "$routeParams", "User", "Organization",
($scope, $http, $routeParams, User, Organization) ->
  if $routeParams.id is "new"
    $scope.object = new User()
  else if $routeParams.id
    $scope.object = User.get id: $routeParams.id
  else
    $scope.object = null
  $scope.loadUsers = ->
    $scope.users = User.query()
  $scope.save = (obj) ->
    success = (data, headers) ->
      $scope.loadUsers()
      console.log "SUCCESS", data, headers()
      $scope.$emit "go", path: "/users"
    failure = (data, headers) ->
      console.log "ERROR", data
      alert "error"
    if obj.id?
      User.update {id: obj.id}, {user: obj.toData()}, success, failure
    else
      User.save {user: obj.toData()}, success, failure
  $scope.formTitle = ->
    if $scope.object?.id then "Edit \"#{$scope.object.name()}\"" else "New user"
  $scope.loadUsers()
]
