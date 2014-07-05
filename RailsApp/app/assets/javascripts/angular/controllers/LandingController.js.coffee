angular.module("cfeed").controller "LandingCtrl", [
  "$scope", "$http", "$interval"
  ($scope, $http, $interval) ->
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

    $interval( ->
      $scope.recentPosts.shift()
    , 3000);

  ]
