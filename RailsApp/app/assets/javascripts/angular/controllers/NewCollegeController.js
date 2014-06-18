angular.module('cfeed')
  .controller('NewCollegeController', ['$scope', '$http', '$modalInstance', function($scope, $http, $modalInstance) {

  $scope.newCollege = {}
  $scope.allColleges = []

  $scope.ok = function () {
    $modalInstance.close($scope.newCollege);
  };

  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  }

  $scope.getAllColleges()
  
  $scope.getColleges = function() {
    return $http.get('api/v1/colleges')
      .then(function(res){
        console.log(res.data)
        return res.data
      })
  }
}]);



