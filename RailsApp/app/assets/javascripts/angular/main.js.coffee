angular.module "cfeed", ["ui.bootstrap", "ngAnimate", "ngResource"]
angular.element(document).ready ->

angular.module("cfeed").run ["$rootScope", "$resource", ($rootScope, $resource) ->
  $rootScope.College = $resource('/api/v1/colleges/:collegeId', {collegeId: '@id'})
  $rootScope.Post = $resource('/api/v1/colleges/:collegeId/posts/:postId', {postId: '@id'})
  $rootScope.Comment = $resource('/api/v1/colleges/:collegeId/posts/:postId/comments/:commentId', {commentId: '@id'})
]
#$("i.tip").tooltip();
