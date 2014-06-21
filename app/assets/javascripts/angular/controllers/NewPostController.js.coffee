angular.module("cfeed").controller "NewPostController", [
  "$scope"
  "$http"
  "$modalInstance"
  ($scope, $http, $modalInstance) ->
    $scope.newPost = {}
    $scope.allColleges = []
    $scope.ok = ->
      $modalInstance.close $scope.newPost
      return

    $scope.cancel = ->
      $modalInstance.dismiss "cancel"
      return

    $scope.getAllColleges = ->
      $http.get("api/v1/colleges").then (res) ->
        $scope.allColleges = res.data
        return

      return

    $scope.getAllColleges()
]
