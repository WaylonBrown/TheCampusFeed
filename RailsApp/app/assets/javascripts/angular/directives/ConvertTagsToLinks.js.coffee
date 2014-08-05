angular.module("cfeed").directive "converttagstolinks", ->
  restrict: "A",
  link: (scope, element, attrs) ->
    element.context.onloadeddata = ->
      console.log('it loaded')
      return
    console.log(element)
    console.log(element.context)
    console.log(element.context.textContent)
    return

