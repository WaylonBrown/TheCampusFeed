angular.module("cfeed").directive "hastooltip", ->
  restrict: "A"
  link: (scope, element, attrs) ->
    element.tooltip()
    return

