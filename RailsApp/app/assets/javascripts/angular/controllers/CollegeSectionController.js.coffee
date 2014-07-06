angular.module("cfeed").controller "CollegeSectionController", [
  "$scope"
  "$http"
  "$modal"
  "$timeout"
  "$resource"
  "$rootScope"
  ($scope, $http, $modal, $timeout, $resource, $rootScope) ->
    $scope.collegeOptions = {}
    $scope.collegeOptions.pageNo = 1
    $scope.collegeOptions.perPage = 10
    $scope.collegeOptions.total = 0
    $scope.collegeOptions.searchText = ""
    $scope.collegeOptions.colleges = []
    $scope.collegeOptions.error = false
    $scope.populateColleges = ->
      searchPortion = ""
      searchPortion = "/search/" + $scope.collegeOptions.searchText  if $scope.collegeOptions.searchText.trim().length > 0
      $http.get("api/v1/colleges" + searchPortion + "?page=" + $scope.collegeOptions.pageNo + "&per_page=" + $scope.collegeOptions.perPage).success((res) ->
        $scope.collegeOptions.error = false
        $scope.collegeOptions.colleges = res
        return
      ).error (res) ->
        $scope.collegeOptions.colleges = []
        $scope.collegeOptions.error = true
        return

      return

    $scope.setTotal = ->
      searchPortion = ""
      searchPortion = "/search/" + $scope.collegeOptions.searchText  if $scope.collegeOptions.searchText.trim().length > 0
      $http.get("api/v1/colleges" + searchPortion + "/count")
      .success((res) ->
        $scope.collegeOptions.error = false
        $scope.collegeOptions.total = res
        return
      ).error (res) ->
      $scope.collegeOptions.total = 0
      $scope.collegeOptions.error = true
      return

      return

    $scope.updateTotalAndPopulate = ->
      $scope.setTotal()
      $scope.populateColleges()
      return

    $scope.updateTotalAndPopulate()
    $scope.openCreateModal = ($event) ->
      $event.stopPropagation()
      modal = $modal.open(
        templateUrl: "partials/newCollege"
        controller: "NewCollegeController"
      )
      modal.result.then ((newCollege) ->
        $http.college("api/v1/colleges/",
          college:
            name: newCollege.name
        ).then ((res) ->
          $scope.updateTotalAndPopulate()
          return
        ), ->
          console.log "Error sending new college."
          return

        return
      ), ->

      return


    #Modal dismissed
    $scope.editCollege = ($event, college) ->
      $event.stopPropagation()
      $($event.currentTarget).parents(".panel").children(".panel-collapse")
      .height "auto"
      college.isEditing = true
      return

    $scope.finishedEditingCollege = (college, sendChanges) ->
      college.isEditing = false
      if sendChanges
        $http.put("api/v1/colleges/" + college.id, college).then (res) ->
          $scope.updateTotalAndPopulate()
          return

      return

    $scope.deleteCollege = ($event, college) ->
      $event.stopPropagation()
      $http.delete("api/v1/colleges/" + college.id).then (res) ->
        $scope.updateTotalAndPopulate()
        return

      return

]
