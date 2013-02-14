
@RootController = ["$scope", "$http", "$routeParams", "$location", "$rootScope", "CurrentUser", "Category", "Organization",
($scope, $http, $routeParams, $location, $rootScope, CurrentUser, Category, Organization) ->
  $rootScope.brand = "TimeOverflow"
  $scope.whoAmI = () ->
    $scope.currentUser ?= CurrentUser.get()
  $scope.logout = () ->
    $http.delete("/signout").success ->
      $scope.currentUser = undefined
      $location.path "/"
      $location.search {}
  $rootScope.pageTitle = () ->
    # [ $rootScope.brand, ($rootScope.title || [])... ][-2..-1].join " » "
    $rootScope.brand
  $scope.loadCategories = ->
    $scope.categories = Category.query {}, (data) ->
      c.addToIdentityMap() for c in data
  $scope.loadOrganizations = ->
    $scope.organizations = Organization.query {}, (data) ->
      c.addToIdentityMap() for c in data
  $scope.loadCategories()
  $scope.loadOrganizations()
  $scope.$on "go", (ev, where) ->
    $location[d] where[d] for d in ["path", "search"] when where[d]
  $scope.$on "loadCategories", (ev) -> $scope.loadCategories()
  $scope.$on "loadOrganizations", (ev) -> $scope.loadOrganizations()
  $rootScope.$on "event:auth-loginRequired", -> $rootScope.showLogin = true
  $rootScope.$on "event:auth-loginConfirmed", -> $rootScope.showLogin = false
]


@LoginController = ["$scope", "$http", "authService",
($scope, $http, authService) ->
  $scope.submit = () ->
    $http.post("/signin", $scope.login).success(-> authService.loginConfirmed())
]

@TitleController = ["$scope", "$rootScope", ($scope, $rootScope) ->
  angular.noop()
]


@CategoriesController = ["$scope", "$http", "$routeParams", "Category",
($scope, $http, $routeParams, Category) ->
  $scope.whoAmI()
  if $routeParams.id is "new"
    $scope.object = new Category()
    $scope.$emit "crumbs",
      href: "/categories"
      display: "Categories"
    ,
      href: "/categories/new"
      display: "NEW CATEGORY"
  else if $routeParams.id
    $scope.object = Category.get id: $routeParams.id, (data) ->
      $scope.$emit "crumbs",
        href: "/categories"
        display: "Categories"
      ,
        href: "/categories/#{$routeParams.id}"
        display: data.name
  else
    $scope.object = null
    $scope.$emit "crumbs",
      href: "/categories"
      display: "Categories"
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



@OrganizationsController = ["$scope", "$http", "$routeParams", "$rootScope", "Organization",
($scope, $http, $routeParams, $rootScope, Organization) ->
  $scope.whoAmI()
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




@UsersController = ["$scope", "$http", "$routeParams", "$location", "User", "Organization", "Category",
($scope, $http, $routeParams, $location, User, Organization, Category) ->
  $scope.whoAmI()
  if $routeParams.id?
    $scope.object = User.get id: $routeParams.id
  else
    $scope.object = new User()
  $scope.show = {}
  $scope.User = User
  $scope.Category = Category
  $scope.usersByCategory = {}
  $scope.showCat = (id) ->
    id of $scope.usersByCategory
  $scope.depth = (cat, range) ->
    dpth = if p = cat.parent then $scope.depth(p) + 1 else 0
    if range then [0...dpth] else dpth
  $scope.loadUsers = ->
    $scope.users = User.query (data) ->
      User.addToIdentityMap(data)
      usersByCategory = {}
      for u in data
        for cat in u.category_ids
          c = Category.identityMap[cat]
          usersByCategory[c.id] ?= [] while (c = c.parent)?
          usersByCategory[cat] ?= []
          usersByCategory[cat].push u.id

      angular.copy usersByCategory, $scope.usersByCategory
      data
  $scope.showEmailsToCopy = ->
    window.prompt "Copiar usando Ctrl-C", (u.email for u in $scope.users).join(", ")
  $scope.save = (obj) ->
    success = (data, headers) ->
      $scope.loadUsers()
      console.log "SUCCESS", data, headers()
      $location.path "/users"
    failure = (data, headers) ->
      console.log "ERROR", data
      alert "error"
    if obj.id?
      User.update {id: obj.id}, {user: obj}, success, failure
    else
      User.save {user: obj}, success, failure
  $scope.formTitle = ->
    if $scope.object?.id then "Edit \"#{$scope.object.name()}\"" else "New user"
  $scope.loadUsers()
]
