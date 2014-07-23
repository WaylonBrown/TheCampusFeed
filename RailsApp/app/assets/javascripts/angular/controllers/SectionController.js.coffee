angular.module("cfeed").controller "SectionController", [
  "$scope"
  "$rootScope"
  "$resource"
  ($scope, $rootScope, $resource) ->
    $scope.sections = [
      {
        template: "partials/adminPosts"
      }
      {
        template: "partials/adminColleges"
      }
      {
        template: "partials/adminComments"
      }
    ]

]
