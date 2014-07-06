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

    $rootScope.College = $resource('/api/v1/colleges/:collegeId', {collegeId: '@id'})
    $rootScope.Post = $resource('/api/v1/colleges/:collegeId/posts/:postId', {postId: '@id'})
]
