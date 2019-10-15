class AuthService {
  bool isLoggedIn = false;
  String redirectUrl = '/home';

  login(String username, String password) async {
    // const r = await this.http
    //   .post<LoginToken>(getTokenUrl, qs.stringify(body), {
    //     headers: {
    //       'content-type': 'application/x-www-form-urlencoded',
    //     },
    //   })
    //   .toPromise();
    // if(r.success && r.data.token){
    //   const _token: string = r.data.token;
    //   await this.tokenService.setToken(_token);
    //   this.isLoggedIn = true;
    //   return true;
    // }

    // this.isLoggedIn = false;
    // alert(r.message);
    // return false;
  }

  /// 退出登陆，清理token
  logout() async {
    this.isLoggedIn = false;
  }

  /// 获取用户的信息
  getUserInfo() async {
    // return this.http
    //   .post<UserProfile>(profileUrl, null, {
    //     observe: 'response',
    //   })
    //   .toPromise();
  }
}
