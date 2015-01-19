angular.module("cfeed").directive "postcomments", ["$rootScope", ($rootScope)->
  restrict: "A"
  link: (scope, element, attrs) ->
    maxComments = parseInt(attrs["postcomments"])
    comments = $rootScope.Comment.query({collegeId: attrs['postcollege'], postId: attrs['postid']}, ->
      truncatedComments = comments.slice(comments.length-maxComments)
      truncatedComments.forEach (comment)->
        element.append("<div class=\"comment\">#{comment.text}</div>")
        return
      $rootScope.$broadcast('masonry.reload');
    )
    return

]
