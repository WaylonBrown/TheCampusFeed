# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

angular.module("cfeed").controller("showPostCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.options = {}
  $scope.allComments = {}

  $scope.populateComments = ->
    $http.get("/api/v1/posts/" + "1" + "/comments").success((res) ->
      $scope.allComments = res
      return
    ).error (res) ->
      $scope.allComments = []
      return

    return

  $scope.populateComments()
])