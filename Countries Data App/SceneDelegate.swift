//
//  SceneDelegate.swift
//  Countries Data App
//
//  Created by Mohd Saif on 13/10/25.
//

import SwiftUI
import UIKit

/// App scene entry for UI setup.
///
/// File responsibility:
/// - Create app window.
/// - Set the first screen for the app flow.
///
/// File connections:
/// - Starts `CountryHomeView` from `Presentation/SwiftUI/CountryHomeView.swift`.
/// - Wraps the SwiftUI view inside `UIHostingController` and `UINavigationController`.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        let vc = HomeViewController(viewModel: AppContainer.shared.makeHomeViewModel())
        let rootView = CountryHomeView()
        let hostingController = UIHostingController(rootView: rootView)

//        window?.rootViewController = UINavigationController(rootViewController: hostingController)
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
