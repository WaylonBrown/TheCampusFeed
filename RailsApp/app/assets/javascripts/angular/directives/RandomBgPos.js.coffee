angular.module("cfeed").directive "randombgpos", ->
  restrict: "A"
  link: (scope, element, attrs) ->
    console.log 'sadf'
    element.css('background-position-x',
        Math.floor((Math.random() * 600) + 1) - 300)
    element.css('background-position-y',
        Math.floor((Math.random() * 600) + 1) - 300)
    return