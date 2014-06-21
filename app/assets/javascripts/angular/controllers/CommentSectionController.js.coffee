angular.module("cfeed").controller "CommentSectionController", [
  "$scope"
  "$http"
  "$modal"
  "$timeout"
  ($scope, $http, $modal, $timeout) ->
    $scope.commentOptions = {}
    $scope.commentOptions.pageNo = 1
    $scope.commentOptions.perPage = 10
    $scope.commentOptions.total = 0
    $scope.commentOptions.searchText = ""
    $scope.commentOptions.comments = []
    $scope.commentOptions.error = false
    $scope.commentOptions.postId = ""

    $scope.populateComments = ->
      searchPortion = ""
      searchPortion = "/search/" + $scope.commentOptions.searchText  if $scope.commentOptions.searchText.trim().length > 0
      $http.get("api/v1/posts/" + $scope.commentOptions.postId + "/comments" + searchPortion + "?page=" + $scope.commentOptions.pageNo + "&per_page=" + $scope.commentOptions.perPage).success((res) ->
        $scope.commentOptions.error = false
        $scope.commentOptions.comments = res
        return
      ).error (res) ->
        $scope.commentOptions.comments = []
        $scope.commentOptions.error = true
        return

      return

    $scope.setTotal = ->
      searchPortion = ""
      searchPortion = "/search/" + $scope.commentOptions.searchText  if $scope.commentOptions.searchText.trim().length > 0
      $http.get("api/v1/posts/" + $scope.commentOptions.postId + "/comments" + searchPortion + "/count").success((res) ->
        $scope.commentOptions.error = false
        $scope.commentOptions.total = res
        return
      ).error (res) ->
        $scope.commentOptions.total = 0
        $scope.commentOptions.error = true
        return

      return

    $scope.updateTotalAndPopulate = ->
      if $scope.commentOptions.postId.length > 0
        $scope.setTotal()
        $scope.populateComments()
      return

    $scope.updateTotalAndPopulate()
    $scope.openCreateModal = ($event) ->
      $event.stopPropagation()
      modal = $modal.open(
        templateUrl: "partials/newComment"
        controller: "NewCommentController"
      )
      modal.result.then ((newComment) ->
        console.log newComment
        $http.post("api/v1/posts/" + $scope.commentOptions.postId + "/comments",
          comment:
            text: newComment.text
        ).then ((res) ->
          $scope.updateTotalAndPopulate()
          return
        ), ->
          console.log "Error sending new comment."
          return

        return
      ), ->

      return

    
    #Modal dismissed
    $scope.editComment = ($event, comment) ->
      $event.stopPropagation()
      $($event.currentTarget).parents(".panel").children(".panel-collapse").height "auto"
      comment.isEditing = true
      return

    $scope.finishedEditingComment = (comment, sendChanges) ->
      comment.isEditing = false
      if sendChanges
        $http.put("api/v1/posts/" + comment.post_id + "/comments/" + comment.id, comment).then (res) ->
          $scope.updateTotalAndPopulate()
          return

      return

    $scope.deleteComment = ($event, comment) ->
      $event.stopPropagation()
      $http.delete("api/v1/posts/" + comment.post_id + "/comments/" + comment.college_id + "/comments/" + comment.id).then (res) ->
        $scope.updateTotalAndPopulate()
        return

      return

    $scope.$on "show.bs.collapse", ->
      console.log "it collapsed"
      return

]
