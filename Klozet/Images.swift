// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  typealias AssetColorTypeAlias = NSColor
  typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias AssetColorTypeAlias = UIColor
  typealias Image = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

@available(*, deprecated, renamed: "ImageAsset")
typealias AssetType = ImageAsset

struct ImageAsset {
  fileprivate var name: String

  var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

struct ColorAsset {
  fileprivate var name: String

  #if swift(>=3.2)
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
  #endif
}

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
enum Asset {
  static let cancel = ImageAsset(name: "Cancel")
  static let clock = ImageAsset(name: "Clock")
  static let clockSelected = ImageAsset(name: "ClockSelected")
  static let currentLocation = ImageAsset(name: "CurrentLocation")
  static let currentLocationHeading = ImageAsset(name: "CurrentLocationHeading")
  static let currentLocationSelected = ImageAsset(name: "CurrentLocationSelected")
  static let filter = ImageAsset(name: "Filter")
  static let noCamera = ImageAsset(name: "NoCamera")
  static let pin = ImageAsset(name: "Pin")
  static let price = ImageAsset(name: "Price")
  static let priceSelected = ImageAsset(name: "PriceSelected")
  static let settings = ImageAsset(name: "Settings")
  static let toilet = ImageAsset(name: "Toilet")
  static let toiletPic = ImageAsset(name: "ToiletPic")
  static let walking = ImageAsset(name: "Walking")
  static let walkingDetail = ImageAsset(name: "WalkingDetail")
  static let whiteCross = ImageAsset(name: "WhiteCross")
  static let addIcon = ImageAsset(name: "addIcon")
  static let addIconSelected = ImageAsset(name: "addIconSelected")
  static let backChevron = ImageAsset(name: "backChevron")
  static let connectionError = ImageAsset(name: "connectionError")
  static let coolGrey = ColorAsset(name: "coolGrey")
  static let cornflower = ColorAsset(name: "cornflower")
  static let darkBlueGrey = ColorAsset(name: "darkBlueGrey")
  static let defaultTextColor = ColorAsset(name: "defaultTextColor")
  static let directionIcon = ImageAsset(name: "directionIcon")
  static let directionIconHeading = ImageAsset(name: "directionIconHeading")
  static let directionIconSelected = ImageAsset(name: "directionIconSelected")
  static let dodgerBlue = ColorAsset(name: "dodgerBlue")
  static let editIcon = ImageAsset(name: "editIcon")
  static let greenSuccess = ColorAsset(name: "greenSuccess")
  static let icon = ImageAsset(name: "icon")
  static let lightGold = ColorAsset(name: "lightGold")
  static let listIcon = ImageAsset(name: "listIcon")
  static let listIconSelected = ImageAsset(name: "listIconSelected")
  static let loadingIconShadow = ImageAsset(name: "loadingIconShadow")
  static let mapIconSelected = ImageAsset(name: "mapIconSelected")
  static let mapIconUnselected = ImageAsset(name: "mapIconUnselected")
  static let melon = ColorAsset(name: "melon")
  static let paleGrey = ColorAsset(name: "paleGrey")
  static let salmon = ColorAsset(name: "salmon")
  static let silver = ColorAsset(name: "silver")
  static let skyBlue = ColorAsset(name: "skyBlue")
  static let squash = ColorAsset(name: "squash")
  static let stormyBlue = ColorAsset(name: "stormyBlue")
  static let toiletSignIcon = ImageAsset(name: "toiletSignIcon")
  static let toxicGreen = ColorAsset(name: "toxicGreen")

  // swiftlint:disable trailing_comma
  static let allColors: [ColorAsset] = [
    coolGrey,
    cornflower,
    darkBlueGrey,
    defaultTextColor,
    dodgerBlue,
    greenSuccess,
    lightGold,
    melon,
    paleGrey,
    salmon,
    silver,
    skyBlue,
    squash,
    stormyBlue,
    toxicGreen,
  ]
  static let allImages: [ImageAsset] = [
    cancel,
    clock,
    clockSelected,
    currentLocation,
    currentLocationHeading,
    currentLocationSelected,
    filter,
    noCamera,
    pin,
    price,
    priceSelected,
    settings,
    toilet,
    toiletPic,
    walking,
    walkingDetail,
    whiteCross,
    addIcon,
    addIconSelected,
    backChevron,
    connectionError,
    directionIcon,
    directionIconHeading,
    directionIconSelected,
    editIcon,
    icon,
    listIcon,
    listIconSelected,
    loadingIconShadow,
    mapIconSelected,
    mapIconUnselected,
    toiletSignIcon,
  ]
  // swiftlint:enable trailing_comma
  @available(*, deprecated, renamed: "allImages")
  static let allValues: [AssetType] = allImages
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

extension Image {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX) || os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

extension AssetColorTypeAlias {
  #if swift(>=3.2)
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: asset.name, bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
  #endif
}

private final class BundleToken {}
