angular.module('timeoverflow').controller 'UserListCtrl', ["$scope", "$modal", "$http", "$location", ($scope, $modal, $http, $location) ->

  $scope.sortBy = (field) ->
    $scope.sort = if $scope.sort == field then "-#{field}" else field
  $scope.filterTerm = ''
  $scope.$location = $location

  ['filterTerm', 'sort'].map (prop) ->
    Object.defineProperty($scope, prop,
      get: ->
        if prop == 'sort' and $location.search()[prop] == undefined
          'member_id'
        else
          $location.search()[prop]
      set: (val) -> $location.search(prop, val || null)
    )

  $scope.toggle_manager = (user) ->
    $modal.open(
      templateUrl: 'confirm_toggle_manager.html'
      size: 'sm'
      scope: $scope
      controller: ["$scope", ($scope) -> $scope.username = user.username]
    ).result
    .then(-> $http.put(user.toggle_manager_link))
    .then(-> user.manager = !user.manager)

  $scope.toggle_active = (user) ->
    $modal.open(
      templateUrl: 'confirm_toggle_active.html'
      size: 'sm'
      scope: $scope
      controller: ["$scope", ($scope) -> $scope.username = user.username]
    ).result
    .then(-> $http.put(user.toggle_active_link))
    .then(-> user.active = !user.active)
]

# override this in a view where the organizations are needed
angular.module('timeoverflow').value 'Organizations', []

angular.module('timeoverflow').filter 'timeBalance', ->
  (seconds) ->
    if seconds isnt 0
      minutes = Math.abs(seconds) / 60
      hours = (minutes / 60) >> 0
      minutes %= 60
      minutes >>= 0;
      if seconds < 0 then "-#{hours}:#{minutes}" else "#{hours}:#{minutes}"
    else
      "—"
