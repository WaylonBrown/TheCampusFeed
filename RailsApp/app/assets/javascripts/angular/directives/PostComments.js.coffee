angular.module("cfeed").directive "postcomments", ["$rootScope", ($rootScope)->
  restrict: "A"
  link: (scope, element, attrs) ->
    comments = $rootScope.Comment.query({collegeId: attrs['postcollege'], postId: attrs['postcomments']}, ->
      comments.forEach (comment)->
        element.append("<div class=\"comment\">#{comment.text}</div>")
        return
    )
    return

]
