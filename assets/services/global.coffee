angular.module("mean.system").factory "Global", [->
  _this = this
  _this._data =
    user: window.user
    authenticated: !!window.user
    dealcount: window.dealCount
    usercount: window.userCount

  _this._data
]