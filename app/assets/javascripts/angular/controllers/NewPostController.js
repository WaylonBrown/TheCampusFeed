angular.module('cfeed')
  .controller('NewPostController', ['$scope', '$http', '$modalInstance', function($scope, $http, $modalInstance) {

  $scope.newPost = {}
  $scope.allColleges = []

  $scope.ok = function () {
    $modalInstance.close($scope.newPost);
  };

  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  }

  $scope.getAllColleges = function(){
    $http.get('api/v1/colleges')
      .then(function(res){
        $scope.allColleges = res.data
      })
  }

  $scope.getAllColleges()
  
}]);



