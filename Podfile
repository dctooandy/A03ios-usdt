# Uncomment the next line to define a global platform for your project
use_frameworks!
platform :ios,'10.0'

target 'HYNewNest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HYNewNest
  pod 'Reachability'
  pod 'AFNetworking'
  pod 'MJRefresh'
  pod 'YYModel'
  pod 'SDWebImage', '~> 5.11.1'
  pod 'Masonry'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'UITableView+FDTemplateLayoutCell'
  pod 'IQKeyboardManager'
  pod 'FCUUID'
  pod 'SJVideoPlayer'
  pod 'JKCategories'
  pod 'JXCategoryView'
  # webSocket
  pod 'SocketRocket', '~> 0.5.1'
  pod 'CocoaAsyncSocket'
  pod 'LookinServer', :configurations => ['Debug']
  pod 'KYNetworking',:git =>'http://10.66.72.115/mobile-iOS-Library/KYNetworking.git'
  # 公共接口
  pod 'IVPublicAPILibrary',:git =>'http://10.66.72.115/mobile-iOS-Library/IVPublicAPILibrary.git'
  # 网络模块
  pod 'IVNetworkLibrary2.0',:git =>'http://10.66.72.115/mobile-iOS-Library/IVNetworkLibrary2.0.git'
  # 缓存模块
  pod 'IVCacheLibrary',:git =>'http://10.66.72.115/mobile-iOS-Library/IVCacheLibrary.git'
  # 网络检测
  pod 'IVCheckNetworkLibrary',:git =>'http://10.66.72.115/mobile-iOS-library/IVCheckNetworkLibrary.git'
  # 天网埋点
  pod 'IVLoganAnalysis',:git =>'http://10.66.72.115/mobile-iOS-library/IVLoganAnalysis.git'
  # OCSS客服
  pod 'CSSerVice',:git =>'http://10.66.72.115/mobile-iOS-library/ocss-webview-sdk-demo-ios.git' ,:tag=>'1.1.0'
  # 微脉圈
  pod 'IVCustomerServiceLibrary',:git =>'http://10.66.72.115/mobile-iOS-library/IVCustomerServiceLibrary'
  pod 'IVIMPublicLibrary',:git =>'http://10.66.72.115/mobile-iOS-library/IVIMPublicLibrary.git'
  # 3S
  pod 'IN3SAnalyticsSDK',:git =>'http://10.66.72.115/mobile-iOS-library/IV3SLibrary.git'
  pod 'IVGameLibrary',:git =>'http://10.66.72.115/mobile-iOS-Library/IVGameLibrary.git',:branch=>'v2.0'

  target 'HYNewNestTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HYNewNestUITests' do
    # Pods for testing
  end

end


# 注意：【IVNetworkLibrary2.0】文件：IVHTTPBaseRequest.h & .m 有自定义内容；
#      【IVCheckNetworkLibrary】文件：IVCheckNetworkWrapper.m (aggameh5) 有自定义内容；
#      【NSNumber+JKRound】文件：NSNumber+JKRound.m 有自定义内容
#      【SJVideoPlayer】的仓库地址被公司黑名单。。
#       因此谨慎使用'pod update'。
# 请使用'pod update XXX'更新单个库，然后将'IVCheckNetworkLibrary'和'IVPublicAPILibrary'的bitcode配置改为NO (IVNetworkLibrary2.0 网络库不支持bitcode 埋下的坑)
# 如果更新了，请根据下面的代码查找后直接替换；请求AE临时开通权限更新SJ库

#  typedef NS_ENUM(NSInteger,IVNEnvironment){
#      IVNEnvironmentTest = 0,// 测试
#      IVNEnvironmentDevelop = 1,// 开发
#  //    IVNEnvironmentPublishTest = 2,// 运测
#      IVNEnvironmentPublish = 2,// 运营
#  };

#  switch (self.environment) {
#  //        case IVNEnvironmentTest:
#      case IVNEnvironmentDevelop:
#          keyEnum = @"1";
#          break;
#      default:
#          keyEnum = @"0";
#          break;
#  }

#  switch (type) {
#      case IVKCheckNetworkTypeGateway:
#          typeName = @"gateway";
#          subUrl = @"health";
#          request = [IVCheckGatewayRequest manager];
#          ((IVCheckGatewayRequest *)request).url = url;
#          break;
#      case IVKCheckNetworkTypeGameDomian:
#          typeName = @"game domain";
#          subUrl = @"/aggameh5/version.txt";    // add this
#          break;
#      case IVKCheckNetworkTypeDomain:
#          typeName = @"domain";
#          break;
#      case IVKCheckNetworkTypeOnline:
#          typeName = @"online";
#          subUrl = @"health";
#          request = [IVCheckGatewayRequest manager];
#          ((IVCheckGatewayRequest *)request).url = url;
#          break;
#      default:
#          typeName = [NSString stringWithFormat:@"other%@",@(type)];
#          break;
#  }

# - (NSString*)jk_toDisplayNumberWithDigit:(NSInteger)digit
# {
#     NSString *result = nil;
#     NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
#     [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
#     [formatter setRoundingMode:NSNumberFormatterRoundFloor];
#     [formatter setMaximumFractionDigits:digit];
#     [formatter setMinimumFractionDigits:digit];
#     result = [formatter  stringFromNumber:self];
#     if (result == nil)
#         return @"";
#     return result;
#
# }
