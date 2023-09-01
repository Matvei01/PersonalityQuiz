//
//  SceneDelegate.swift
//  PersonalityQuiz
//
//  Created by Matvei Khlestov on 21.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let introductionVC = IntroductionViewController()
        window.rootViewController = introductionVC
        window.makeKeyAndVisible()
    }
}

