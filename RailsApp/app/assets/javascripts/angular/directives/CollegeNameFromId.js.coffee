angular.module("cfeed").directive "collegenamefromid", ["$http", ($http)->
  restrict: "A",
  template: '{{college_name}}'
  link: (scope, element, attrs) ->
    $http.get("/api/v1/colleges/" + attrs.cid + "/").success((res)->
      scope.college_name = res.name
      console.log 'asdzzzf'
    ).error(->
      console.log('a')
      return
    )

    return

]