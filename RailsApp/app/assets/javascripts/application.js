// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//
//= require angular
//= require bootstrap
//= require angular-ui-bootstrap-tpls
//
//= require_tree .

app = angular.module('cfeed', ["ui.bootstrap"])


app.controller('PostSectionController', ['$scope', '$http', function($scope, $http) {
    $scope.pageNo = 1;
    $scope.perPage = 10;
    $scope.total = 0;
    $scope.searchText = "";
    $scope.posts = [];

    $scope.populatePosts = function(){
      $scope.posts = [];
      var searchPortion = "";
      console.log($scope.searchText)
      if(this.searchText.trim().length > 0){
        searchPortion = '/search/'+this.searchText
      }
      $http.get('api/v1/posts'+searchPortion+'?page='+this.pageNo+'&per_page='+this.perPage)
       .then(function(res){
         console.log(res.data)
         $scope.posts = res.data;
         console.log($scope.posts)
       });
    }

    $scope.setTotal = function(){
      var searchPortion = "";
      if(this.searchText.trim().length > 0){
        searchPortion = '/search/'+this.searchText
      }
      $http.get('api/v1/posts'+searchPortion+'/count')
       .then(function(res){
          $scope.total = res.data;
        });
    }

    $scope.updateTotalAndPopulate = function(){
      $scope.setTotal();
      $scope.populatePosts();
    }

    $scope.updateTotalAndPopulate();

    $scope.$on('show.bs.collapse', function(){
      console.log('asdf');
    });

  }]
);

app.directive('hastooltip', function () {
  return {
    restrict: 'A',
    link: function (scope, element, attrs) {
      element.tooltip();
    }
  };
});

angular.element(document).ready(function () {
  //$("i.tip").tooltip();
});

app.controller('SectionController', ['$scope', function($scope) {
    //$scope.
    $scope.sections = [
      {'template': 'fragments/admin_posts.html'}
      //{'controller': 'PostSectionController', 'title': 'Posts', 'isOpen': 'true'}
    ]
}]);
