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
  pod 'SDWebImage'
  pod 'SDWebImage/GIF'
  pod 'Masonry'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'UITableView+FDTemplateLayoutCell'
  pod 'IQKeyboardManager'
  pod 'FCUUID'
  pod 'SJVideoPlayer'
  pod 'JKCategories'
  # 个推
#  pod 'GTSDK'
  # webSocket
  pod 'SocketRocket'
  pod 'CocoaAsyncSocket'
  
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
  pod 'CSSerVice',:git =>'http://10.66.72.115/mobile-iOS-library/ocss-webview-sdk-demo-ios.git' ,:tag=>'0.1.2'
  
  pod 'LookinServer', :configurations => ['Debug']
  
  
  # 注意：【IVNetworkLibrary2.0】文件：IVHTTPBaseRequest.h & .m 有自定义内容；【IVCheckNetworkLibrary】文件：IVCheckNetworkWrapper.m (aggameh5) 有自定义内容；且【SJVideoPlayer】的仓库地址被公司黑名单。。。因此谨慎使用'pod install'。
  # 使用'pod update CSSerVice'更新单个库，然后将'IVCheckNetworkLibrary'和'IVCheckNetworkLibrary'的bitcode配置改为NO (网络库埋下的坑)
  # 如果不慎更新了 请根据下面的代码查找后直接替换；请求AE临时开通权限
  
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
#//            subUrl = @"health";
#          subUrl = @"/_glaxy_83e6dy_/health";
#          request = [IVCheckGatewayRequest manager];
#          ((IVCheckGatewayRequest *)request).url = url;
#          break;
#      case IVKCheckNetworkTypeGameDomian:
#          typeName = @"game domain";
#          subUrl = @"/aggameh5/version.txt";
#          break;
#      case IVKCheckNetworkTypeDomain:
#          typeName = @"domain";
#          break;
#      default:
#          typeName = [NSString stringWithFormat:@"other%@",@(type)];
#          break;
#  }

  target 'HYNewNestTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HYNewNestUITests' do
    # Pods for testing
  end

end
