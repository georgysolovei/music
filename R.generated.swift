//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 colors.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 0 files.
  struct file {
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 4 images.
  struct image {
    /// Image `Image`.
    static let image = Rswift.ImageResource(bundle: R.hostingBundle, name: "Image")
    /// Image `camera`.
    static let camera = Rswift.ImageResource(bundle: R.hostingBundle, name: "camera")
    /// Image `cd`.
    static let cd = Rswift.ImageResource(bundle: R.hostingBundle, name: "cd")
    /// Image `sound-wave`.
    static let soundWave = Rswift.ImageResource(bundle: R.hostingBundle, name: "sound-wave")
    
    /// `UIImage(named: "Image", bundle: ..., traitCollection: ...)`
    static func image(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.image, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "camera", bundle: ..., traitCollection: ...)`
    static func camera(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.camera, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "cd", bundle: ..., traitCollection: ...)`
    static func cd(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.cd, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sound-wave", bundle: ..., traitCollection: ...)`
    static func soundWave(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.soundWave, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 0 nibs.
  struct nib {
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 2 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `ArtistCell`.
    static let artistCell: Rswift.ReuseIdentifier<ArtistCell> = Rswift.ReuseIdentifier(identifier: "ArtistCell")
    /// Reuse identifier `TrackCell`.
    static let trackCell: Rswift.ReuseIdentifier<TrackCell> = Rswift.ReuseIdentifier(identifier: "TrackCell")
    
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 1 view controllers.
  struct segue {
    /// This struct is generated for `ArtistController`, and contains static references to 1 segues.
    struct artistController {
      /// Segue identifier `TrackListSegue`.
      static let trackListSegue: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, ArtistController, TrackListController> = Rswift.StoryboardSegueIdentifier(identifier: "TrackListSegue")
      
      /// Optionally returns a typed version of segue `TrackListSegue`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func trackListSegue(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, ArtistController, TrackListController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.artistController.trackListSegue, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 3 storyboards.
  struct storyboard {
    /// Storyboard `Artist`.
    static let artist = _R.storyboard.artist()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `LogIn`.
    static let logIn = _R.storyboard.logIn()
    
    /// `UIStoryboard(name: "Artist", bundle: ...)`
    static func artist(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.artist)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "LogIn", bundle: ...)`
    static func logIn(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.logIn)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try logIn.validate()
      try artist.validate()
      try launchScreen.validate()
    }
    
    struct artist: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let artistController = StoryboardViewControllerResource<ArtistController>(identifier: "ArtistController")
      let bundle = R.hostingBundle
      let name = "Artist"
      let trackListController = StoryboardViewControllerResource<TrackListController>(identifier: "TrackListController")
      
      func artistController(_: Void = ()) -> ArtistController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: artistController)
      }
      
      func trackListController(_: Void = ()) -> TrackListController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: trackListController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "cd") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'cd' is used in storyboard 'Artist', but couldn't be loaded.") }
        if UIKit.UIImage(named: "camera") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'camera' is used in storyboard 'Artist', but couldn't be loaded.") }
        if _R.storyboard.artist().trackListController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'trackListController' could not be loaded from storyboard 'Artist' as 'TrackListController'.") }
        if _R.storyboard.artist().artistController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'artistController' could not be loaded from storyboard 'Artist' as 'ArtistController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if UIKit.UIImage(named: "sound-wave") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'sound-wave' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    struct logIn: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let logInController = StoryboardViewControllerResource<LogInController>(identifier: "LogInController")
      let name = "LogIn"
      
      func logInController(_: Void = ()) -> LogInController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: logInController)
      }
      
      static func validate() throws {
        if _R.storyboard.logIn().logInController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'logInController' could not be loaded from storyboard 'LogIn' as 'LogInController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
