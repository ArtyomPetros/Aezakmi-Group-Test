//
//  TestApp1App.swift
//  TestApp1
//
//  Created by Артём Петросян on 13.09.2024.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import Firebase
import GoogleSignInSwift

@main
struct TestApp1App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        FirebaseApp.configure()
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: PermissionsView())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
//extension UIApplication {
//    func getRootViewController() -> UIViewController {
//        guard let screen = connectedScenes.first as? UIWindowScene else {
//            return .init()
//        }
//        guard let root = screen.windows.first?.rootViewController else {
//            return .init()
//        }
//        return root
//    }
//}
