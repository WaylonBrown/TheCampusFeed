angular.module('cfeed')
  .controller('CollegeSectionController', ['$scope', '$http', '$modal', '$timeout', function($scope, $http, $modal, $timeout) {

  $scope.collegeOptions = {};
  $scope.collegeOptions.pageNo = 1;
  $scope.collegeOptions.perPage = 10;
  $scope.collegeOptions.total = 0;
  $scope.collegeOptions.searchText = "";
  $scope.collegeOptions.colleges = [];
  $scope.collegeOptions.error = false;

  $scope.populateColleges = function(){
    var searchPortion = "";
    if($scope.collegeOptions.searchText.trim().length > 0){
      searchPortion = '/search/'+$scope.collegeOptions.searchText
    }
    $http.get('api/v1/colleges'+searchPortion+'?page='+$scope.collegeOptions.pageNo+'&per_page='+$scope.collegeOptions.perPage)
      .success(function(res){
        $scope.collegeOptions.error = false;
        $scope.collegeOptions.colleges = res;
      }).error(function(res){
        $scope.collegeOptions.colleges = [];
        $scope.collegeOptions.error = true;
      });
  }

  $scope.setTotal = function(){
    var searchPortion = "";
    if($scope.collegeOptions.searchText.trim().length > 0){
      searchPortion = '/search/'+$scope.collegeOptions.searchText
    }
    $http.get('api/v1/colleges'+searchPortion+'/count')
      .success(function(res){
        $scope.collegeOptions.error = false;
        $scope.collegeOptions.total = res;
      }).error(function(res){
        $scope.collegeOptions.total = 0;
        $scope.collegeOptions.error = true;
      });
  }

  $scope.updateTotalAndPopulate = function(){
    $scope.setTotal();
    $scope.populateColleges();
  }

  $scope.updateTotalAndPopulate();

  $scope.openCreateModal = function($event){
    $event.stopPropagation()
    var modal = $modal.open({
      templateUrl: 'partials/newCollege',
      controller: 'NewCollegeController',
    })
    modal.result.then(function(newCollege) {
      console.log(newCollege)
      $http.college('api/v1/colleges/', {college: {name: newCollege.name}})
        .then(function(res){
          $scope.updateTotalAndPopulate();
        }, function(){
          console.log('Error sending new college.')
        })
    },
    function () {
      //Modal dismissed
    })
  }

  $scope.editCollege = function($event, college){
    $event.stopPropagation()
    $($event.currentTarget).parents('.panel').children('.panel-collapse').height('auto');
    college.isEditing = true;
  }

  $scope.finishedEditing = function(college, sendChanges){
    college.isEditing = false;
    if(sendChanges){
      console.log('asdff')
      $http.put('api/v1/colleges/'+college.id, college)
        .then(function(res){
          $scope.updateTotalAndPopulate();
        });
    }
  }

  $scope.deleteCollege = function($event, college){
    $event.stopPropagation()
    $http.delete('api/v1/colleges/'+college.id)
      .then(function(res){
        $scope.updateTotalAndPopulate();
      });
  }

  $scope.$on('show.bs.collapse', function(){
    console.log('it collapsed');
  });
}]);
