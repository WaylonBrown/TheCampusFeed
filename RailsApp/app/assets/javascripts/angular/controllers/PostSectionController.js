angular.module('cfeed')
  .controller('PostSectionController', ['$scope', '$http', '$modal', function($scope, $http, $modal) {

  $scope.postOptions = {};
  $scope.postOptions.pageNo = 1;
  $scope.postOptions.perPage = 10;
  $scope.postOptions.total = 0;
  $scope.postOptions.searchText = "";
  $scope.postOptions.posts = [];
  $scope.postOptions.error = false;

  $scope.populatePosts = function(){
    var searchPortion = "";
    if($scope.postOptions.searchText.trim().length > 0){
      searchPortion = '/search/'+$scope.postOptions.searchText
    }
    $http.get('api/v1/posts'+searchPortion+'?page='+$scope.postOptions.pageNo+'&per_page='+$scope.postOptions.perPage)
      .success(function(res){
        $scope.postOptions.error = false;
        $scope.postOptions.posts = res;
      }).error(function(res){
        $scope.postOptions.posts = [];
        $scope.postOptions.error = true;
      });
  }

  $scope.setTotal = function(){
    var searchPortion = "";
    if($scope.postOptions.searchText.trim().length > 0){
      searchPortion = '/search/'+$scope.postOptions.searchText
    }
    $http.get('api/v1/posts'+searchPortion+'/count')
      .success(function(res){
        $scope.postOptions.error = false;
        $scope.postOptions.total = res;
      }).error(function(res){
        $scope.postOptions.total = 0;
        $scope.postOptions.error = true;
      });
  }

  $scope.updateTotalAndPopulate = function(){
    $scope.setTotal();
    $scope.populatePosts();
  }

  $scope.updateTotalAndPopulate();

  $scope.openCreateModal = function($event){
    $event.stopPropagation()
    $modal.open({
      templateUrl: 'partials/newPost',
      controller: 'NewPostController',
      resolve: {
      }
    })
  }

  $scope.$on('show.bs.collapse', function(){
    console.log('it collapsed');
  });
}]);
