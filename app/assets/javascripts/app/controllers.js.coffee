
@RootController = ["$scope", "$http", "$routeParams", "Category", ($scope, $http, $routeParams, Category) ->
  $scope.brand = "TimeOverflow"
  $scope.loadCategories = ->
    $scope.categories = Category.query {}, (data) ->
      c.addToIdentityMap() for c in data
  $scope.loadCategories()
]

# class Category
#   constructor: (attrs) -> angular.extend this, attrs
#   fqn: -> @_fqn ?= if @parent then @parent.fqn() + ' > ' + @name else @name



@CategoriesController = ["$scope", "$http", "$routeParams", "Category", ($scope, $http, $routeParams, Category) ->
  console.log $routeParams
  if $routeParams.id is "new"
    $scope.object = new Category()
  else if $routeParams.id
    $scope.object = Category.get id: $routeParams.id
  else
    $scope.object = null

  # $scope.show = (obj) ->
  #   if obj? then obj = new Category(obj)
  #   $scope.detailView = if $scope.object = obj then "detail" else "list"
  $scope.save = (obj) ->
    success = (data, status, headers, config) ->
      $scope.loadCategories()
      console.log "SUCCESS", data, status, headers, config

      # $scope.show(null)
    failure = (data, status, headers, config) ->
      console.log "ERROR", data, status, headers, config
      alert "error"
    if obj.id?
      Category.update {id: obj.id}, {category: obj.toData()}, success, failure
    else
      Category.save {category: obj.toData()}, success, failure
  $scope.formTitle = ->
    if $scope.object?.id then "Edit \"#{$scope.object.name}\"" else "New category"
  # $scope.show(null)
]




@UsersController = ["$scope", "$http", "$routeParams", "User", ($scope, $http, $routeParams, User) ->
  $scope.resource_name = "user"
  $scope.base_path = "/users"
  $scope.loadUsers = ->
    $scope.users = User.query()
  $scope.show = (obj) ->
    $scope.detailView = if $scope.object = obj then "detail" else "list"
  $scope.save = (obj) ->
    success = (data, status, headers, config) ->
      $scope.loadUsers()
      console.log "SUCCESS", data, status, headers, config
      $scope.show(null)
    failure = (data, status, headers, config) ->
      console.log "ERROR", data, status, headers, config
      alert "error"
    if obj.id?
      User.update {id: obj.id}, {user: obj.toData()}, success, failure
    else
      User.save {user: obj.toData()}, success, failure
  $scope.formTitle = ->
    if $scope.object?.id then "Edit \"#{$scope.object.name()}\"" else "New " + $scope.resource_name
  $scope.loadUsers()
  $scope.show(null)
]
