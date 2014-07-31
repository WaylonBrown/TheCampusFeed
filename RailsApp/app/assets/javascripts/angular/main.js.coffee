angular.module "cfeed", ["ui.bootstrap", "ngAnimate", "ngResource", "infinite-scroll"]
angular.element(document).ready ->

angular.module("cfeed").run ["$rootScope", "$resource", ($rootScope, $resource) ->
  $rootScope.College = $resource('/api/v1/colleges/:collegeId', {collegeId: '@id'}, {
    trending: {method: 'GET', url: '/api/v1/colleges/trending/', isArray: true}
  })
  $rootScope.Post = $resource('/api/v1/colleges/:collegeId/posts/:postId', {postId: '@id'})
  $rootScope.Comment = $resource('/api/v1/colleges/:collegeId/posts/:postId/comments/:commentId', {commentId: '@id'}, {
  })
  $rootScope.Tag = $resource('/api/v1/tags/:tagId', {tagId: '@id'}, {
    trending: {method: 'GET', url: '/api/v1/tags/trending/', isArray: true}
  })
]
#$("i.tip").tooltip();
