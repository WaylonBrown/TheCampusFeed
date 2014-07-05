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

    $scope.removeInterval = $interval( ->
      $scope.recentPosts.shift()
      if($scope.recentPosts.length > 0 && $scope.recentPosts.length < 7)
        $interval.cancel($scope.removeInterval)
    , 3000);

  ]
