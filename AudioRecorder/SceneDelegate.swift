//
//  SceneDelegate.swift
//  AudioRecorder
//
//  Created by Paweł Brzozowski on 28/12/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Casting scene parameter as a UIWindowScene
        guard let baseWindowScene = (scene as? UIWindowScene) else {
            return
        }
        
        // Creating main screen and nagigationController
        let AudioRecorderVC = AudioRecorderViewController()
        let navigationController = UINavigationController()
        
        // Using UINavigationController I am adding rootScreenVC to the stack.
        navigationController.pushViewController(AudioRecorderVC, animated: true)
        
        // Create a new UIWindow based on the UIWindowScene we previously created.
        // This can be easily done by doing a UIWindow(windowScene: scene), where scene is the UIWindowScene variable we have previously created using the guard statement.
        let window = UIWindow(windowScene: baseWindowScene)
        
        // Set the UIWindow to be visible and be the main window for this app simply doing .makeKeyAndVisible()
        window.makeKeyAndVisible()
        
        // Set the .rootViewController from UIWindow. Set a navigation controller to that variable,
        window.rootViewController = navigationController // To use the UINavigationController
        
        // SceneDelegate already has variable called window of type UIWindow. Set this variable to the UIWindow that was created earlier.
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

