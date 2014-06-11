angular.module('cfeed').directive('hastooltip', function () {
  return {
    restrict: 'A',
    link: function (scope, element, attrs) {
      element.tooltip();
    }
  };
});
