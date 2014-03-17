function MainCtrl($scope, query) {
	$scope.table = function() {
		return query.list();
	};