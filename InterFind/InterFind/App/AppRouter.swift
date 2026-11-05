//
//  AppRouter.swift
//  InterFind
//
//  Cambia la pantalla raíz de la app (onboarding, login o pestañas) sin apilar modales.
//

import UIKit

enum AppRouter {

    static func initialViewController() -> UIViewController {
        if LoginController.isLoggedIn() {
            return IFTabBarController(homeViewController: IFHomeViewController())
        }
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: Constants.hasSeenOnboardingKey)
        let root: UIViewController = hasSeenOnboarding ? IFLoginViewController() : IFOnboardingVC()
        return UINavigationController(rootViewController: root)
    }

    static func showHome() {
        setRoot(IFTabBarController(homeViewController: IFHomeViewController()))
    }

    static func showLogin() {
        setRoot(UINavigationController(rootViewController: IFLoginViewController()))
    }

    private static func setRoot(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first else { return }
        window.rootViewController = viewController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}
