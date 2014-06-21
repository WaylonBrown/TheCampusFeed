angular.module("cfeed").controller "SectionController", [
  "$scope"
  ($scope) ->
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
