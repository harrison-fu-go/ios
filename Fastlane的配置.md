# Fastlane自动化打包

1. 安装Fastlane

2. 在项目根目录下初始化fastlane, =>  fastlane init

3. 初始化后，配置 Fastfile 和 Appfile

    Fastfile设置一些lane, demo如下： 
    # This file contains the fastlane.tools configuration
# You can find the documentation at https://docs.fastlane.tools
#
# For a list of all available actions, check out
#
#     https://docs.fastlane.tools/actions
#
# For a list of all available plugins, check out
#
#     https://docs.fastlane.tools/plugins/available-plugins
#

# Uncomment the line if you want fastlane to automatically update itself 
# update_fastlane

default_platform(:ios)

platform :ios do

  desc "Push a new beta build to TestFlight"
  lane :beta_new do
    increment_build_number(xcodeproj: "XXXXXX.xcodeproj")

    #同步签名，证书
    get_certificates           # invokes cert
    get_provisioning_profile   # invokes sigh

    build_app(workspace: "XXXXXX.xcworkspace", scheme: "XXXXXX-alpha", clean: true)
    upload_to_testflight
  end

  # 用于发布alpha版本，注意：自动分支为：feature_alpha
  lane :alpha do
        #设置分支
        sh "git stash save 'fastlane'"
        sh "git checkout feature_alpha"
        sh "git pull origin feature_alpha  --no-edit"
        sh "git stash pop"
    upload_flow(scheme:'XXXXXX-alpha')
  end

  # 用于发布alpha_internal 版本，注意：自动分支为：develop_multiple_product
  lane :alpha_internal do
          brunch_control()
    upload_flow(scheme:'XXXXXX-alpha')
  end

   lane :alpha_auto do
        #设置分支
        sh "git stash save 'fastlane'"
        sh "git checkout debug/develop_auto"
        sh "git pull origin debug/develop_auto  --no-edit"
        sh "git stash pop"
    upload_flow(scheme:'XXXXXX-alpha')
  end

  
   # 用于发布Corsola alpha 版本，注意：自动分支为：feature_alpha
  lane :alpha_corsola do
    brunch_control()
    upload_flow(scheme:'XXXXXX-alpha(Corsola)')
  end

   # 用于发布Ear Color 版本，注意：自动分支为：feature_alpha
  lane :alpha_color do
    brunch_control()
    upload_flow(scheme:'XXXXXX-alpha(EarColor)')
  end

   # 用于发布Crobat XXXXXX 版本，注意：自动分支为：feature_alpha
  lane :alpha_crobat do
    brunch_control()
    upload_flow(scheme:'XXXXXX-alpha(Crobat)')
  end

   # 用于发布Crobat 23231 版本，注意：自动分支为：feature_alpha
  lane :alpha_donphan do
    brunch_control()
    upload_flow(scheme:'XXXXXX-alpha(Donphan)')
  end

 lane :alpha_entei do
    brunch_control()
    upload_flow(scheme:'XXXXXX-Alpha(Entei)')
  end

  # 用于发布beta版本，注意：自动分支为：feature_beta
  lane :beta do
           #设置分支
        sh "git stash save 'fastlane'"
        sh "git checkout feature_beta"
        sh "git pull origin feature_beta  --no-edit"
        sh "git stash pop"
    upload_flow(scheme:'XXXXXX-beta')
  end

 # 用于发布beta版本，注意：自动分支为：Advance-EQ-for-community
  lane :beta_advance_eq_community do
           #设置分支
        sh "git stash save 'fastlane'"
        sh "git checkout Advance-EQ-for-community"
        sh "git pull origin Advance-EQ-for-community  --no-edit"
        sh "git stash pop"
    upload_flow(scheme:'XXXXXX-beta')
  end

  # 用于发布Media版本，注意：自动分支为：media-20230912, 及时更新。
  lane :media do
        #设置分支
        sh "git stash save 'fastlane'"
        sh "git checkout media-20230912"
        sh "git pull origin media-20230912  --no-edit"
        sh "git stash pop"
        upload_flow(scheme:'XXXXXX-media')
  end

  # 用于发布appstore版本, 注意：手动控制分支 或每次发布正式版需要重新设置下分支
  lane :release do
    #设置分支
        sh "git stash save 'fastlane'"
        sh "git checkout x_release/v2.3.10"
        sh "git pull origin x_release/v2.3.10  --no-edit"
        sh "git stash pop"
    upload_flow(scheme:'XXXXXX-appstore')
  end

# 用于发布release_dvance_eq_community版本, 注意：Advance-EQ-for-community分支
  lane :release_dvance_eq_community do
    #设置分支
        sh "git stash save 'fastlane'"
        sh "git checkout Advance-EQ-for-community"
        sh "git pull origin Advance-EQ-for-community  --no-edit"
        sh "git stash pop"
    upload_flow(scheme:'XXXXXX-appstore')
  end
    
  lane :crobat_beta do
           #设置分支
        sh "git stash save 'fastlane'"
        sh "git checkout XXXXXX-bata"
        sh "git pull origin XXXXXX-bata  --no-edit"
        sh "git stash pop"
    upload_flow(scheme:'XXXXXX-beta')
  end

 lane :crobat_alpha do
           #设置分支
        sh "git stash save 'fastlane'"
        sh "git checkout feature/XXXXXX_alpha"
        sh "git pull origin feature/XXXXXX_alpha --no-edit"
        sh "git stash pop"
    upload_flow(scheme:'XXXXXX-alpha')
  end

  lane :feature_china do
           #设置分支
        sh "git stash save 'fastlane'"
        sh "git checkout feature_alpha_china"
        sh "git pull origin feature_alpha_china  --no-edit"
        sh "git stash pop"
    upload_flow(scheme:'XXXXXX-beta')
  end

  lane :email_aes do
           #设置分支
        sh "git stash save 'fastlane'"
        sh "git checkout feature/email_aes"
        sh "git pull origin feature/email_aes  --no-edit"
        sh "git stash pop"
    upload_flow(scheme:'XXXXXX-alpha')
  end


# ======== Alpha, Beta, Media, AppStore 版本共同上传到TestFlight部分 ============
  lane :upload_flow do |option|
    #pod install
    sh "pod install"

    #Build number加1
    increment_build_number(xcodeproj: "XXXXXX.xcodeproj")

    #同步签名，证书
    get_certificates           # invokes cert
    get_provisioning_profile   # invokes sigh

    #设置并且Build指定的scheme
    t_scheme = option[:scheme]
    build_app(workspace: "XXXXXX.xcworkspace", scheme: t_scheme, clean: true)

    #打包到Testflight
    upload_to_testflight
  end

# ======= Alpha, Beta, Media 版本分支：feature_alpha / develop_multiple_product =======
   lane :brunch_control do
    #设置分支
    sh "git stash save 'fastlane'"
    sh "git checkout feature_alpha"
    sh "git pull origin feature_alpha  --no-edit"
    sh "git stash pop"
   end


# 用于手动发布版本
  lane :manul do
    #pod install
    sh "pod install"
    increment_build_number(xcodeproj: "XXXXXX.xcodeproj")
    #同步签名，证书
    get_certificates           # invokes cert
    get_provisioning_profile   # invokes sigh
    build_app(workspace: "XXXXXX.xcworkspace", scheme: "XXXXXX-appstore", clean: true)
    upload_to_testflight
  end

  
  before_all do |lane,options|
      puts("======== set password: 🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑 =========")
      ENV['FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD'] = 'XXXX-XXXX-XXXX-XXXX'
  end

  after_all do |lane,options|
    puts("======== Sucessfully🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉 =========")
  end
 
  error do |lane, exception, options|
    sh "git stash pop"
    puts("======== Fail ❌❌❌❌❌❌❌❌❌❌❌❌ =========")
  end


end

4. Appfile内容如下： 
    app_identifier("com.nothing.smartcenter") # The bundle identifier of your app
    apple_id("harrison.fu@nothing.tech") # Your Apple Developer Portal username

    itc_team_id("123031749") # App Store Connect Team ID
    team_id("7X4FCHGB38") # Developer Portal Team ID

# For more information about the Appfile, see:
#     https://docs.fastlane.tools/advanced/#appfile

5. 初始化后，配置Gemfile的内容如下 ： 
    source "https://rubygems.org"
    gem "cocoapods"
    gem "fastlane"
    

6. 注意的事项：踩坑。。 

    a. 出现pod install 错误时候，一般是  Gemfile 中少了 gem "cocoapods"
