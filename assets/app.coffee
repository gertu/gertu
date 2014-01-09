angular.module "mean", [
  "ngCookies",
  "ngRoute",
  "ngResource",
  "ui.bootstrap",
  "ui.route",
  "mean.system",
  "mean.users",
  "mean.shops",
  "mean.deals",
  "mean.filters",
  "pascalprecht.translate"
]

angular.module "mean.system", []
angular.module "mean.deals", []
angular.module "mean.users", []
angular.module "mean.shops", []
angular.module "mean.filters", []