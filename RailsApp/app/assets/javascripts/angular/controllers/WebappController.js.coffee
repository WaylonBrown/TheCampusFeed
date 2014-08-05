angular.module("cfeed").controller "WebappCtrl", [
  "$scope", "$http", "$interval", "$resource", "$rootScope"
  ($scope, $http, $interval, $resource, $rootScope) ->
    $scope.tags = {}
    $scope.colleges = {}
    $scope.options = {}
    $scope.options.post_selected = null;

    $scope.posts = {}
    $scope.posts.recentPosts = []
    $scope.posts.currentPage = 1

    $rootScope.College = $resource('/api/v1/colleges/:collegeId', {collegeId: '@id'},{
      trending: {method: 'GET', url: '/api/v1/colleges/trending/', isArray: true}
    })
    $rootScope.Post = $resource('/api/v1/colleges/:collegeId/posts/:postId', {postId: '@id'},{
      recent: {method: 'GET', url: '/api/v1/posts/recent', isArray: true}
    })
    $rootScope.Comment = $resource('/api/v1/colleges/:collegeId/posts/:postId/comments/:commentId', {commentId: '@id'},{
    })
    $rootScope.Tag = $resource('/api/v1/tags/:tagId', {tagId: '@id'}, {
      trending: {method: 'GET', url: '/api/v1/tags/trending/', isArray: true}
    })

    $scope.tags.trendingTags = $rootScope.Tag.trending({page: 1, per_page: 10})
    $scope.colleges.trendingColleges = $rootScope.College.trending({page: 1, per_page: 10})


    $scope.selectPost = (post) ->
      if(post == $scope.options.post_selected)
        $scope.options.post_selected.active = false
        $scope.options.post_selected = null;
      else
        comments = Comment.query({college_id: post.college_id, post_id: post.id}, ->
          if(null != $scope.options.post_selected)
            $scope.options.post_selected.active = false
          post.active = true
          post.comments = comments
          $scope.options.post_selected = post
        )

    $scope.atBottom = () ->
      newPosts = $rootScope.Post.recent({page: $scope.posts.currentPage, per_page: 25}, ->
        $scope.posts.currentPage += 1
        $scope.posts.recentPosts = $scope.posts.recentPosts.concat(newPosts)
      )
]
