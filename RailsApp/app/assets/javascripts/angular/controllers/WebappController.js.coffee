angular.module("cfeed").controller "WebappCtrl", [
  "$scope", "$http", "$interval", "$resource", "$rootScope"
  ($scope, $http, $interval, $resource, $rootScope) ->
    $scope.tags = {}
    $scope.colleges = {}
    $scope.options = {}
    $scope.options.post_selected = null;
    $scope.recentPosts = []

    $rootScope.College = $resource('/api/v1/colleges/:collegeId', {collegeId: '@id'},{
      trending: {method: 'GET', url: '/api/v1/colleges/trending/', isArray: true}
    })
    $rootScope.Post = $resource('/api/v1/colleges/:collegeId/posts/:postId', {postId: '@id'})
    $rootScope.Comment = $resource('/api/v1/colleges/:collegeId/posts/:postId/comments/:commentId', {commentId: '@id'},{
    })
    $rootScope.Tag = $resource('/api/v1/tags/:tagId', {tagId: '@id'}, {
      trending: {method: 'GET', url: '/api/v1/tags/trending/', isArray: true}
    })

    $scope.tags.trendingTags = $rootScope.Tag.trending({page: 1, per_page: 10})
    $scope.colleges.trendingColleges = $rootScope.College.trending({page: 1, per_page: 10})

    $scope.loadRecentPosts = ->
      $http.get("api/v1/posts/recent").success((res) ->
        $scope.recentPosts = res
        return
      ).error (res) ->
        $scope.recentPosts = []
        return
      return

    $scope.loadRecentPosts()

    CommentList = $resource('/api/v1/colleges/:college_id/posts/:post_id/comments/:comment_id',
      {comment_id: '@id'}, {
      });


    $scope.selectPost = (post) ->
      if(post == $scope.options.post_selected)
        $scope.options.post_selected.active = false
        $scope.options.post_selected = null;
      else
        comments = CommentList.query({college_id: post.college_id, post_id: post.id}, ->
          if(null != $scope.options.post_selected)
            $scope.options.post_selected.active = false
          post.active = true
          post.comments = comments
          $scope.options.post_selected = post
        )
]
