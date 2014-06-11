angular.module('cfeed')
  .controller('CollegeSectionController', ['$scope', '$http', '$modal', function($scope, $http, $modal) {

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
    var modal = $modal.open({
      templateUrl: 'partials/newPost',
      controller: 'NewPostController',
    })
    modal.result.then(function(newPost) {
      console.log(newPost)
      $http.post('api/v1/colleges/'+newPost.college_id+'/posts', {post: {text: newPost.text}})
        .then(function(res){
          $scope.updateTotalAndPopulate();
        }, function(){
          console.log('Error sending new post.')
        })
    },
    function () {
      //Modal dismissed
    })
  }

  $scope.$on('show.bs.collapse', function(){
    console.log('it collapsed');
  });
}]);
