@APP.directive "controlGroup", ->
  transclude: true
  restrict: "E"
  scope:
    label: "@"
  template: """
  <div class="control-group">
    <label class="control-label">{{label}}</label>
    <div class="controls" ng-transclude>
    </div>
  </div>
  """
  replace: true
