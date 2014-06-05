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

app.controller('PostSection', ['$scope', '$http', function($scope, $http) {

    $scope.populatePosts = function(){
      $scope.posts = [];
      console.log($scope.currentPage)
      $http.get('api/v1/posts?page='+$scope.curPage+'&per_page=6')
       .then(function(res){
          console.log(res.data)
          $scope.posts = res.data
        });
    }

    $scope.$on('show.bs.collapse', function(){
      console.log('asdf');
    });

    $scope.populatePosts();

    $scope.setPage = function (pageNo) {
      $scope.curPage = pageNo;
    };
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

