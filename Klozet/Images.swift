// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum Asset: String {
  case addIcon = "addIcon"
  case addIconSelected = "addIconSelected"
  case cancel = "Cancel"
  case clock = "Clock"
  case clockSelected = "ClockSelected"
  case connectionError = "connectionError"
  case currentLocation = "CurrentLocation"
  case currentLocationHeading = "CurrentLocationHeading"
  case currentLocationSelected = "CurrentLocationSelected"
  case directionIcon = "directionIcon"
  case directionIconHeading = "directionIconHeading"
  case directionIconSelected = "directionIconSelected"
  case filter = "Filter"
  case icon = "icon"
  case listIcon = "listIcon"
  case listIconSelected = "listIconSelected"
  case mapIconSelected = "mapIconSelected"
  case mapIconUnselected = "mapIconUnselected"
  case noCamera = "NoCamera"
  case pin = "Pin"
  case price = "Price"
  case priceSelected = "PriceSelected"
  case settings = "Settings"
  case toilet = "Toilet"
  case toiletPic = "ToiletPic"
  case walking = "Walking"
  case walkingDetail = "WalkingDetail"
  case whiteCross = "WhiteCross"

  var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: rawValue, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: rawValue)
    #elseif os(watchOS)
    let image = Image(named: rawValue)
    #endif
    guard let result = image else { fatalError("Unable to load image \(rawValue).") }
    return result
  }
}
// swiftlint:enable type_body_length

extension Image {
  convenience init!(asset: Asset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.rawValue, in: bundle, compatibleWith: nil)
    #elseif os(OSX) || os(watchOS)
    self.init(named: asset.rawValue)
    #endif
  }
}

private final class BundleToken {}
