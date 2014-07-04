angular.module("cfeed").controller "NewCommentController", [
  "$scope"
  "$http"
  "$modalInstance"
  ($scope, $http, $modalInstance) ->
    $scope.newPost = {}
    $scope.allPosts = []
    $scope.ok = ->
      $modalInstance.close $scope.newComment
      return

    $scope.cancel = ->
      $modalInstance.dismiss "cancel"
      return

    $scope.getAllPosts = ->
      $http.get("api/v1/posts").then (res) ->
        $scope.allPosts = res.data
        return

      return

    $scope.getAllPosts()
]
