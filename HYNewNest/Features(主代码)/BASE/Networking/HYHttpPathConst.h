//
//  HYHttpPathConst.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/20.
//  Copyright © 2020 james. All rights reserved.
//

#ifndef HYHttpPathConst_h
#define HYHttpPathConst_h


#pragma mark - H5
#define H5URL_Pub_VipRecord     @"/pub_site/vip_record"    // 兑换记录
#define H5URL_VipZzzp           @"/sudoku"                 // 至尊转盘
#define H5URL_Pub_UsdtTutorial  @"/pub_site/tutorialReference"  // usdt存取新手指南
#define H5URL_BBS               @"/app_site_bbs"                    // 论坛
#define H5URL_Pub_Starall       @"/pub_site/starall"       // 星级特权
#define H5URL_Pub_Coin          @"/pub_site/coin"          // 首存活動
#define H5URL_Pub_yeb           @"/pub_site/yeb"           // 余额宝

#pragma mark - API PATH

/// 拼接path部分    glaxy_a03 -> glaxy_83e6dy
//#define kGatewayPath(api)       [NSString stringWithFormat:@"%@", api]  //基础网关
#define kGatewayExtraPath(api)  [NSString stringWithFormat:@"_extra_/%@", api]  //产品网关

#pragma mark 公共
#define config_welcome  @"welcome"
#define config_upgradeApp      @"upgrade"   //检测版本更新
#define config_callBackPhone   @"callback"  //消息中心电话回访
#define config_home_otherGame @"83e6dy/home/other" //获取其他游戏列表
#define config_areaLimit @"areaLimit" // 地区限制
#define config_liveChatAddress @"liveChatAddressOCSS" //客服
#define config_dynamicQuery @"dynamic/query" //获取动态表单数据 （live800客服，充提指南...）
#define config_switchAccount @"customer/switchAccount"    //切换子账号 USDT<-->人民币
//#define config_getTopDomain  @"a03/getTopDomainAddress" //white list

#define config_queryDSBRank @"83e6dy/activity/queryBaijialeRank" //首页大神榜

#define config_createUdid    @"customer/createCustomerUdid"  //创建自定义udid
#define config_superSignSend     @"ips/ipsSuperSignSend"         //超级签名个推

#pragma mark 登录注册/用户
#define config_h5Ticket @"createH5TempTicket"
#define config_bindMobileNoV2 @"customer/bindMobileNoV2" //绑定手机号v2
#define config_SendCodePhone @"phone/sendCode"  //请求手机号验证码  1.注册 2.登录 3.手机绑定 4.找回密码 5.手机修改 7.资料修改 9.常规验证 11.找回账号
#define config_preLogin  @"customer/preLogin"   //登录前查询是否需要图形验证码
#define config_generateCaptcha   @"captcha/generate"   //生成图片验证码
#define config_generateHanCaptcha   @"captcha/generateCaptcha"   //生成汉字图片验证码
#define config_validateHanCaptcha   @"captcha/validateCaptcha"   //校验汉字图片验证码

#define config_LoginEx @"customer/loginEx"  //模糊登录
#define config_sendCodeByLoginName  @"sms/sendCodeByLoginName"  // 通过用户名发送验证码
#define config_modifyPwdBySmsCode   @"customer/modifyPwdBySmsCode"  //确认修改密码
#define config_modifyPwd   @"customer/modifyPwd"  //修改密码
#define config_reBindMobileNoV2 @"customer/reBindMobileNoV2"  //重新绑定手机号v2
#define config_loginWith2FA @"customer/loginWith2FA" //异地登陆验证

#define config_registUserName   @"customer/createRealAccount"  //用户名注册
#define config_loginMessageIdAndLoginName     @"customer/loginByValidateId" //用户名登录
#define config_forgetPassword_validate   @"customer/preForgetPwdByMobileNo" //忘记密码第一步-验证

#define config_logout          @"customer/logout"
#define config_getByLoginName    @"customer/getByLoginName"  //根据token获取会员信息

#define config_createTryAccount   @"customer/createTryAccount"  //试玩登录
//#define config_autoLoginByToken  @"customer/getByToken"   //自动登录

#define config_new_requestAvatars @"83e6dy/queryAvatars" //修改头像时 请求头像列表

#define config_new_queryMyBonus @"83e6dy/promo/a03MyPromo"  //获取我的红利列表

#define config_new_queryImageList @"83e6dy/queryImageList" //通用查询接口 用于查询图片组及每个图片的附属信息

#define config_betAmountLevel @"83e6dy/getBetAmountLevelConfig" //获取投注额
#define config_getBalanceInfo @"customer/getBalance" //获取用户额度信息
//#define config_getByLoginNameEx @"customer/getByLoginNameEx"  //获取用户信息

#pragma mark 好友推荐
#define config_queryAgentRecord  @"83e6dy/agentRecodTotalSum"  //获取好友推荐所有消息
#define config_superCopartnerActy @"83e6dy/activity/newapi/tjhy"

#pragma mark 站内信
#define config_queryAnnoumces  @"message/queryAnnounces"  //获取公告
#define config_subscrib_query   @"subscribe/query" //查询会员通知设置
#define config_letter_query  @"letter/query" //查询站内信 查询未读数
#define config_subscrib_modify  @"subscribe/modify" //修改员订阅设置

#pragma mark 游戏
#define config_queryGames @"game/queryGames" // 查询游戏线路
#define config_inGame   @"game/inGame"     //进入游戏大厅
//#define config_outGame   @"game/outGame"     //退出游戏大厅

#define config_sugestion  @"createSuggest" //用户意见反馈
#define config_querySugestion  @"querySuggests" //查询意见反馈
#define config_changeLimitBonus  @"limitRed/modify" //修改限红
#define config_new_queryByKeyList  @"83e6dy/queryByKeyList" //获取体育竞猜广告图片  查询游戏平台platform AG TTG

#pragma mark 提现地址管理
#define config_getRealNamePhone @"customer/modifyCustomerRealNamePhone" //修改手机和姓名
#define config_createBank      @"account/createBank"    //添加银行卡号
#define config_createBitCoin   @"account/createBtc"   //添加比特币账户
#define config_create          @"account/create"    //添加小金库账户
#define config_createGoldAccount @"account/createGoldAccount" //创建小金库账户
#define config_getQueryCard    @"account/query" //查询有多少卡绑定， 银行卡管理界面
#define config_deleteAccount   @"account/delete"  //删除银行卡
#define config_verifySmsCode   @"phone/verifySmsCode" //获取validateId
#define config_modifyUserInfo  @"customer/modify" //绑定真实姓名
#define config_getByCardBin    @"getByCardBin" //获取银行名称

#pragma mark 洗码
#define config_xmQueryXmpPlatform @"xm/queryXmpPlatformRequest"   //最新的查询洗码类型对应的厅列表
#define config_xmCalcAmountV3     @"xm/calcAmountV3"   // 查询洗码平台类型额度列表
#define config_xmcreateRequest     @"xm/createRequest" // 创建洗码提案
#define config_xmdeleteRequest     @"xm/deleteRequest" // 删除洗码记录
#define config_xmCheckIsCanXm      @"83e6dy/szsc/isxm"    // 查询是否可以洗码

#pragma mark 取款
#define config_drawCreateRequest  @"withdraw/createRequest"   //取款 提现接口
#define config_currencyExchange   @"deposit/currencyExchange"  //取款 当前汇率
#define config_transfer_to_local @"game/transferToLocal" //账户明细 转至本地
#define config_drawCancelRequest  @"withdraw/cancelRequest" // 取款 “等待状态”取消订单
#define config_calculateSeparate  @"withdraw/calculator"   //计算CNY取款返利拆分

#pragma mark 新钱包
#define config_getBalances       @"getBalances" //主账号查询子账号额度
#define config_walletCoupon      @"83e6dy/proxy/wallet/coupon" // 获取优惠券列表

#pragma mark 风采
#define config_getArticels  @"83e6dy/getArticles" //查询投注详情  电游投注详情用

#pragma mark 交易记录
//#define config_queryTransWithCheck @"deposit/queryTransWithCheck" //废弃
#define config_queryTrans @"deposit/queryTrans" //查询交易记录中的 充值 一项
#define config_queryWithDraw @"withdraw/queryRequest" //提现 查询交易记录中的转账 一项
#define config_queryWithXM @"xm/queryRequest" //洗码 查询交易记录中的转账 一项
#define config_queryWithIntegral @"integral/queryIntegralLogs" //积分 查询交易记录中的转账 一项
#define config_queryWithPromo @"promo/queryRequest" //优惠领取 查询交易记录中的转账 一项
#define config_vault_yebInterestCreditLogs @"yeb/yebInterestCreditLogs" //查询交易记录中的 小金库一项
#define config_queryCreditLogs @"credit/queryCreditLogs" //查询交易记录中的转账 一项
#define config_deleteWithdraw @"withdraw/deleteRequest" //交易记录 删除提现
#define config_queryBets    @"bet/queryBetListByPage"  //投注记录 查询电游各厅投注总数
#define config_reminder     @"message/remain"   // 催单

#pragma mark 支付
#define config_queryPayWaysV3   @"deposit/queryPayWaysV3"  //查询支付方式
#define config_queryBQBanks        @"deposit/queryBQBanks"  // 查询公司BQ可用的银行列表用于支付

#define config_queryOnlineBanks    @"deposit/queryOnlineBanks"  //查询在线银行卡，在线支付，银行，扫码支付
#define config_queryAmountList    @"deposit/queryAmountList" // 查询手动BQ和手动银行存款限额列表

#define config_BQPayment        @"deposit/BQPayment"  //支付宝支付
#define config_deleteTrans      @"deposit/deleteTrans" //交易记录 删除充值
#define config_queryDepositBankInfos @"deposit/queryDepositBankInfos"  //查询电子货币渠道
#define config_createOnlineOrder   @"deposit/createOnlineOrder"  // 创建订单（网银在线 扫码支付 比特币支付 币付宝 小金库）
#define config_createOnlineOrderV2   @"deposit/createOnlineOrderV2"
#define config_createManualDepositRequest @"deposit/createManualDepositRequest" //创建手动支付订单（USDT公链）
#define config_queryDepositCounter @"deposit/queryDepositCounter"   //查询存款收银台地址接口

#pragma mark 电游
#define config_queryPlayLog      @"queryPlayLog" //获取最近玩过的游戏
#define config_queryElecGame      @"game/queryGameList" //获取其电子游戏分页列表
#define config_updateFavorite     @"game/updateFavorite"  //修改游戏收藏
#define config_queryFavoriteGame  @"game/queryFavorite"  //查询游戏收藏

#pragma mark VIP私享会
#define activity_vipSxhReport   @"83e6dy/activity/vipsxh/war/report" //月报-个人战报
#define activity_vipSxhHome     @"83e6dy/activity/vipsxh/home" //私享会首页
#define activity_vipSxhRank     @"83e6dy/activity/vipsxh/rank" //大神榜
#define activity_vipSxhDraw     @"promo/83e6dy/draw" //领取入会礼金
#define activity_vipSxhFrame    @"83e6dy/activity/vipsxh/frame" //是否弹窗月报
#define activity_vipSxhIdentity @"83e6dy/activity/vipsxh/identity" //累计身份
#define activity_vipSxhApply    @"83e6dy/activity/vipsxh/apply" //领取礼物 （累计身份和大转盘）
#define activity_vipSxhReceiveAward     @"promo/83e6dy/common/receive/award" //领取记录
#define activity_vipSxhAwardDetail      @"83e6dy/activity/vipsxh/detail" //礼物详情

#pragma mark 新手任务
#define config_newapiTask       @"83e6dy/activity/newapi/task" //新手任务

#pragma mark 余额宝
#define config_yebPromo         @"83e6dy/activity/newapi/promo" //昨日收益和季度利息 & 存送券
#define config_yebTransferIn    @"yeb/transferIn"   // 转入
#define config_yebTransferOut   @"yeb/transferOut"  // 转出
#define config_yebTransferLogs  @"yeb/yebTransferLogs" // 余额宝交易记录
#define config_yebConfig        @"yeb/yebConfig" // 查询余额宝配置

#endif /* HYHttpPathConst_h */
