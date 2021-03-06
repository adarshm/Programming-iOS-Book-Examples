

import UIKit


/*
This app comes in two flavors: Normal, and iCloud-enabled.
So how do you enable it for iCloud? Just turn on iCloud under Capabilities.
*/


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var ubiq : URL!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        // this is the other part of iCloud-enablement
        // if we get a ubiquity container, we are good to go!
        // other classes will see that we have set ubiq and will use it
        // NB should start by asking for the file manager's ubiquityIdentityToken
        // if it doesn't exist, there is no iCloud account
        DispatchQueue.global(qos:.default).async {
            let fm = FileManager.default
            let ubiq = fm.url(forUbiquityContainerIdentifier:nil)
            print("ubiq: \(ubiq as Any)")
            DispatchQueue.main.async {
                self.ubiq = ubiq
            }
        }
        
        
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("called application(_:open:options:)", url) // not actually implemented, just testing
        return false
    }

}

/*
An incoherency is what should happen if the user switches on iCloud
in midstream, while using the app or between uses of the app. We should detect this, and we should
move the documents between worlds. When we detect that iCloud has been switched from off to on,
we can call setUbiquitous:itemAtURL:destinationURL:error: to make this move.
However, it is not so obvious what to do if iCloud is switched from on to off,
as the document is now no longer available to us to rescue. Again, see
http://developer.apple.com/library/mac/#documentation/General/Conceptual/iCloudDesignGuide/Chapters/iCloudFundametals.html
which discusses how to detect changes in status.
*/

