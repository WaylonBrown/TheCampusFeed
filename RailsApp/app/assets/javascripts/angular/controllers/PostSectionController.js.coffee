angular.module("cfeed").controller "PostSectionController", [
  "$scope"
  "$http"
  "$modal"
  "$timeout"
  "$rootScope"
  ($scope, $http, $modal, $timeout, $rootScope) ->
    $scope.postOptions = {}
    $scope.postOptions.pageNo = 1
    $scope.postOptions.perPage = 10
    $scope.postOptions.total = 0
    $scope.postOptions.searchText = ""
    $scope.postOptions.posts = []
    $scope.postOptions.error = false
    $scope.populatePosts = ->
      searchPortion = ""
      searchPortion = "/search/" + $scope.postOptions.searchText  if $scope.postOptions.searchText.trim().length > 0
      $http.get("api/v1/posts" + searchPortion + "?page=" + $scope.postOptions.pageNo + "&per_page=" + $scope.postOptions.perPage).success((res) ->
        $scope.postOptions.error = false
        $scope.postOptions.posts = res
        return
      ).error (res) ->
        $scope.postOptions.posts = []
        $scope.postOptions.error = true
        return

      return

    $scope.setTotal = ->
      searchPortion = ""
      searchPortion = "/search/" + $scope.postOptions.searchText  if $scope.postOptions.searchText.trim().length > 0
      $http.get("api/v1/posts" + searchPortion + "/count").success((res) ->
        $scope.postOptions.error = false
        $scope.postOptions.total = res
        return
      ).error (res) ->
        $scope.postOptions.total = 0
        $scope.postOptions.error = true
        return

      return

    $scope.updateTotalAndPopulate = ->
      $scope.setTotal()
      $scope.populatePosts()
      return

    $scope.updateTotalAndPopulate()
    $scope.openCreateModal = ($event) ->
      $event.stopPropagation()
      modal = $modal.open(
        templateUrl: "partials/newPost"
        controller: "NewPostController"
      )
      modal.result.then ((newPost) ->
        console.log newPost
        $http.post("api/v1/colleges/" + newPost.college_id + "/posts",
          post:
            text: newPost.text
        ).then ((res) ->
          $scope.updateTotalAndPopulate()
          return
        ), ->
          console.log "Error sending new post."
          return

        return
      ), ->

      return

    
    #Modal dismissed
    $scope.editPost = ($event, post) ->
      $event.stopPropagation()
      $($event.currentTarget).parents(".panel").children(".panel-collapse").height "auto"
      post.isEditing = true
      return

    $scope.finishedEditingPost = (post, sendChanges) ->
      post.isEditing = false
      if sendChanges
        $http.put("api/v1/colleges/" + post.college_id + "/posts/" + post.id, post).then (res) ->
          $scope.updateTotalAndPopulate()
          alsdfslkdf
          return

      return

    $scope.deletePost = ($event, post) ->
      $event.stopPropagation()
      $http.delete("api/v1/colleges/" + post.college_id + "/posts/" + post.id).then (res) ->
        $scope.updateTotalAndPopulate()
        return

      return

    $scope.openComments = ($event, post) ->
      $event.stopPropagation()
      $rootScope.$broadcast("openCommentsForPost", post.id)
      return

    $scope.$on "show.bs.collapse", ->
      console.log "it collapsed"
      return

]
