// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal enum AppUpdate {
    internal static let buttonUpgrade = ImageAsset(name: "Button_Upgrade")
    internal static let softwareUpdateModalUp = ImageAsset(name: "SoftwareUpdate_Modal_up")
    internal static let updateButtonShutDown = ImageAsset(name: "Update_Button_ShutDown")
  }
  internal enum Connection {
    internal static let bleNotConnected = ImageAsset(name: "BLE_NotConnected")
    internal static let batteryNotConnected = ImageAsset(name: "Battery_NotConnected")
    internal static let batteryAir = ImageAsset(name: "Battery_air")
    internal static let bluetoothConnected = ImageAsset(name: "Bluetooth_Connected")
    internal static let connectionConnected = ImageAsset(name: "Connection_Connected")
    internal static let connectionNotConnected = ImageAsset(name: "Connection_NotConnected")
    internal static let mail = ImageAsset(name: "Mail")
    internal static let message = ImageAsset(name: "Message")
    internal static let qq = ImageAsset(name: "QQ")
    internal static let switchesOff = ImageAsset(name: "Switches_Off")
    internal static let switchesOffBackground = ImageAsset(name: "Switches_Off_background")
    internal static let switchesOffButton = ImageAsset(name: "Switches_Off_button")
    internal static let switchesOn = ImageAsset(name: "Switches_On")
    internal static let switchesOnBackground = ImageAsset(name: "Switches_On_background")
    internal static let switchesOnButton = ImageAsset(name: "Switches_On_button")
    internal static let weCom = ImageAsset(name: "WeCom")
    internal static let connectionProductDiagram = ImageAsset(name: "connection_ProductDiagram")
    internal static let connectionProductWireframe = ImageAsset(name: "connection_ProductWireframe")
    internal static let dingtalk = ImageAsset(name: "dingtalk")
    internal static let glassesBig = ImageAsset(name: "glassesBig")
    internal static let music = ImageAsset(name: "music")
    internal static let other = ImageAsset(name: "other")
    internal static let phone = ImageAsset(name: "phone")
    internal static let wachat = ImageAsset(name: "wachat")
  }
  internal enum Guide {
    internal static let appGuideDefault = ImageAsset(name: "AppGuide_Default")
    internal static let informationAbnormal = ImageAsset(name: "InformationAbnormal")
    internal static let operationGuideDefault = ImageAsset(name: "OperationGuide_Default")
    internal static let connectSmartGlasses = ImageAsset(name: "connectSmartGlasses")
    internal static let example1 = ImageAsset(name: "example1")
    internal static let example2 = ImageAsset(name: "example2")
    internal static let example3 = ImageAsset(name: "example3")
    internal static let example4 = ImageAsset(name: "example4")
    internal static let operateSmartGlasses = ImageAsset(name: "operateSmartGlasses")
    internal static let searchDefault = ImageAsset(name: "search_Default")
  }
  internal enum HeaderViews {
    internal static let backDefault = ImageAsset(name: "Back_Default")
    internal static let holoeverLogo = ImageAsset(name: "HOLOEVER-LOGO")
    internal static let menuDefault = ImageAsset(name: "Menu_Default")
    internal static let searchDefault = ImageAsset(name: "search_Default")
  }
  internal enum Mine {
    internal static let batteryDefault = ImageAsset(name: "Battery_Default")
    internal static let defaultAvatar = ImageAsset(name: "DefaultAvatar")
    internal static let defaultAvatard2 = ImageAsset(name: "DefaultAvatard2")
    internal static let firmwareUpdate = ImageAsset(name: "FirmwareUpdate")
    internal static let firmwareUpdateDefault = ImageAsset(name: "FirmwareUpdate_Default")
    internal static let informationAbnormal = ImageAsset(name: "InformationAbnormal")
    internal static let moreConnected = ImageAsset(name: "More_Connected")
    internal static let moreNotConnected = ImageAsset(name: "More_NotConnected")
    internal static let myBottom = ImageAsset(name: "My_Bottom")
    internal static let pushDefault = ImageAsset(name: "Push_Default")
    internal static let radioDefault = ImageAsset(name: "Radio_Default")
    internal static let radioSelected = ImageAsset(name: "Radio_Selected")
    internal static let setUpDefault = ImageAsset(name: "SetUp_Default")
    internal static let softwareUpdate = ImageAsset(name: "SoftwareUpdate")
    internal static let softwareUpdateDefault = ImageAsset(name: "SoftwareUpdate_Default")
    internal static let wearDefault = ImageAsset(name: "Wear_Default")
    internal static let imgDoNotDisturbMode = ImageAsset(name: "img_DoNotDisturbMode")
    internal static let imgRingPattern = ImageAsset(name: "img_RingPattern")
    internal static let imgSilentMode = ImageAsset(name: "img_SilentMode")
    internal static let lyricsDefault = ImageAsset(name: "lyrics_Default")
    internal static let moreDefault = ImageAsset(name: "more_Default")
  }
  internal enum Notice {
    internal static let noticeModal = ImageAsset(name: "Notice_Modal")
  }
  internal enum PlaceHolder {
    internal static let guideBigLoadingPlaceHolder = ImageAsset(name: "guide_big_loading_place_holder")
    internal static let guideSmallLoadingPlaceHolder = ImageAsset(name: "guide_small_loading_place_holder")
  }
  internal enum Launch {
    internal static let holoeverLogo = ImageAsset(name: "holoever_logo")
  }
  internal enum TabBarItems {
    internal static let guideSelected = ImageAsset(name: "Guide_Selected")
    internal static let guideUnselected = ImageAsset(name: "Guide_Unselected")
    internal static let mySelected = ImageAsset(name: "My_Selected")
    internal static let myUnselected = ImageAsset(name: "My_Unselected")
    internal static let connectSelected = ImageAsset(name: "connect_Selected")
    internal static let connectUnselected = ImageAsset(name: "connect_Unselected")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
