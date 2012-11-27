
@RootController = ["$scope", "$http", "$routeParams", "$location", "Category", ($scope, $http, $routeParams, $location, Category) ->
  $scope.brand = "TimeOverflow"
  $scope.loadCategories = ->
    $scope.categories = Category.query {}, (data) ->
      c.addToIdentityMap() for c in data
  $scope.loadCategories()
  $scope.$on "go", (ev, where) ->
    if where.path then $location.path where.path
    if where.search then $location.search where.search
  $scope.$on "loadCategories", (ev) ->
    $scope.loadCategories()
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




@UsersController = ["$scope", "$http", "$routeParams", "User", ($scope, $http, $routeParams, User) ->
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
