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
  
  /// This `R.image` struct is generated, and contains static references to 1 images.
  struct image {
    /// Image `camera`.
    static let camera = Rswift.ImageResource(bundle: R.hostingBundle, name: "camera")
    
    /// `UIImage(named: "camera", bundle: ..., traitCollection: ...)`
    static func camera(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.camera, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 0 nibs.
  struct nib {
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 1 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `Cell`.
    static let cell: Rswift.ReuseIdentifier<ArtistCell> = Rswift.ReuseIdentifier(identifier: "Cell")
    
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 1 view controllers.
  struct segue {
    /// This struct is generated for `LogInController`, and contains static references to 1 segues.
    struct logInController {
      /// Segue identifier `ArtistSegue`.
      static let artistSegue: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, LogInController, ArtistController> = Rswift.StoryboardSegueIdentifier(identifier: "ArtistSegue")
      
      /// Optionally returns a typed version of segue `ArtistSegue`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func artistSegue(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, LogInController, ArtistController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.logInController.artistSegue, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 4 storyboards.
  struct storyboard {
    /// Storyboard `Artist`.
    static let artist = _R.storyboard.artist()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `LogIn`.
    static let logIn = _R.storyboard.logIn()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
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
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
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
      try main.validate()
      try artist.validate()
      try logIn.validate()
    }
    
    struct artist: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let artistController = StoryboardViewControllerResource<ArtistController>(identifier: "ArtistController")
      let bundle = R.hostingBundle
      let name = "Artist"
      
      func artistController(_: Void = ()) -> ArtistController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: artistController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "camera") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'camera' is used in storyboard 'Artist', but couldn't be loaded.") }
        if _R.storyboard.artist().artistController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'artistController' could not be loaded from storyboard 'Artist' as 'ArtistController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
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
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let artistController = StoryboardViewControllerResource<ArtistController>(identifier: "ArtistController")
      let bundle = R.hostingBundle
      let logInController = StoryboardViewControllerResource<LogInController>(identifier: "LogInController")
      let name = "Main"
      
      func artistController(_: Void = ()) -> ArtistController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: artistController)
      }
      
      func logInController(_: Void = ()) -> LogInController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: logInController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "camera") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'camera' is used in storyboard 'Main', but couldn't be loaded.") }
        if _R.storyboard.main().logInController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'logInController' could not be loaded from storyboard 'Main' as 'LogInController'.") }
        if _R.storyboard.main().artistController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'artistController' could not be loaded from storyboard 'Main' as 'ArtistController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
