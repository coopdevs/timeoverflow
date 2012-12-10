@APP.directive "field", ->
  transclude: true
  restrict: "A"
  scope:
    label: "@"
    field: "="
  compile: (tElement, tAttrs, transclude) ->

  template: """
  <div class="control-group">
    <label class="control-label">{{label}}</label>
    <div class="controls" ng-transclude>
    </div>
  </div>
  """
  replace: true
