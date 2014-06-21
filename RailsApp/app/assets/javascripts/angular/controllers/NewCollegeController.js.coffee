angular.module("cfeed").controller "NewCollegeController", [
  "$scope"
  "$http"
  "$modalInstance"
  ($scope, $http, $modalInstance) ->
    $scope.newCollege = {}
    $scope.allColleges = []
    $scope.ok = ->
      $modalInstance.close $scope.newCollege
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
    $scope.getColleges = ->
      $http.get("api/v1/colleges").then (res) ->
        console.log res.data
        res.data

]
