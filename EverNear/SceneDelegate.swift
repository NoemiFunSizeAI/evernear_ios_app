import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let welcomeVC = WelcomeViewController()
        let navController = UINavigationController(rootViewController: welcomeVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
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

    // MARK: - Setup Methods
    
    private func setupOnboardingInterface() {
        let onboardingViewController = OnboardingViewController()
        window?.rootViewController = UINavigationController(rootViewController: onboardingViewController)
    }
    
    private func setupMainInterface() {
        let tabBarController = UITabBarController()
        
        // Home Tab
        let homeViewController = HomeViewController()
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        // Memories Tab
        let memoriesViewController = MemoriesViewController()
        let memoriesNavigationController = UINavigationController(rootViewController: memoriesViewController)
        memoriesNavigationController.tabBarItem = UITabBarItem(title: "Memories", image: UIImage(systemName: "heart.text.square"), tag: 1)
        
        // Companion Tab
        let companionViewController = CompanionViewController()
        let companionNavigationController = UINavigationController(rootViewController: companionViewController)
        companionNavigationController.tabBarItem = UITabBarItem(title: "Companion", image: UIImage(systemName: "message"), tag: 2)
        
        // More Tab
        let moreViewController = MoreViewController()
        let moreNavigationController = UINavigationController(rootViewController: moreViewController)
        moreNavigationController.tabBarItem = UITabBarItem(title: "More", image: UIImage(systemName: "ellipsis.circle"), tag: 3)
        
        tabBarController.viewControllers = [
            homeNavigationController,
            memoriesNavigationController,
            companionNavigationController,
            moreNavigationController
        ]
        
        window?.rootViewController = tabBarController
    }
}
