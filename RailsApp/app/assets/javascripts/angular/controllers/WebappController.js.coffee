angular.module("cfeed").controller "WebappCtrl", [
  "$scope", "$http", "$interval", "$resource"
  ($scope, $http, $interval, $resource) ->
    $scope.options = {}
    $scope.options.post_selected = null;
    $scope.recentPosts = []
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
