//
//  NavigationRouter.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation
import UIKit

enum EmbedController {
    case none
    case navigation
}

enum NavigationOption {
    case none
    case pop
    case popPrevious(Int)
    case popAll

    func navigate(viewController: UIViewController,
                  navigator: UINavigationController,
                  animated: Bool) {
        var viewControllers = navigator.viewControllers
        var willAppendViewController = true

        switch self {
        case .none:
            break
        case .pop:
            viewControllers.removeLast()
            willAppendViewController = false
        case let .popPrevious(count):
            viewControllers.removeLast(count)
        case .popAll:
            viewControllers.removeAll()
        }
        if !viewControllers.contains(viewController), willAppendViewController {
            viewControllers.append(viewController)
        }
        navigator.setViewControllers(viewControllers, animated: animated)
    }
}

enum NavigationRouter {
    static func go(to viewController: BaseDataViewController,
                   in rootVC: BaseRootVC? = nil,
                   embedController: EmbedController = .navigation,
                   data: ViewModelData? = nil,
                   transitionOptions: TransitionOptions) {
        if let window = (UIApplication.shared.delegate as? AppDelegate)?.window {
            viewController.data = data
            let controller = NavigationRouter.getViewController(from: viewController,
                                                                embedController: embedController)
            rootVC?.viewControllers = [controller]
            window.setRootViewController(rootVC ?? controller, options: transitionOptions)
        }
    }

    static func present(from fromVC: UIViewController? = nil,
                        to toVC: BaseDataViewController,
                        menu: Menu? = nil,
                        in rootVC: BaseRootVC? = nil,
                        presentationStyle: UIModalPresentationStyle = .fullScreen,
                        embedController: EmbedController = .none,
                        animated: Bool = true,
                        data: ViewModelData? = nil,
                        transitionStyle: UIModalTransitionStyle? = nil,
                        completion: (() -> Void)? = nil) {
        var presenterVC: UIViewController?
        if fromVC == nil {
            let topMostVC = getTopMostViewController()
            presenterVC = (topMostVC as? BaseDataViewController)?.getRootVC() ?? topMostVC
        } else {
            presenterVC = fromVC
        }
        toVC.menuPageTitle = menu?.menuTitle
        toVC.data = data
        if let transitionStyle = transitionStyle {
            toVC.modalTransitionStyle = transitionStyle
        }
        if presentationStyle == .overCurrentContext {
            presenterVC?.showOverlayView()
        }
        let controller = NavigationRouter.getViewController(from: toVC,
                                                            embedController: embedController)
        rootVC?.viewControllers = [controller]
        (rootVC ?? controller).modalPresentationStyle = presentationStyle
        presenterVC?.present(rootVC ?? controller, animated: animated, completion: completion)
    }

    static func dismiss(viewController: UIViewController? = nil,
                        animated: Bool = true,
                        completion: (() -> Void)? = nil) {
        let aViewController = viewController ?? getTopMostViewController()
        aViewController?.presentingViewController?.currentViewController?.hideOverlayView()
        aViewController?.dismiss(animated: animated, completion: completion)
    }

    static func push(from fromViewController: UIViewController,
                     to viewController: BaseDataViewController,
                     menu: Menu? = nil,
                     animated: Bool = true,
                     navigationOption: NavigationOption = .none,
                     data: ViewModelData? = nil) {
        guard let navigator = fromViewController.navigationController else { return }
        viewController.menuPageTitle = menu?.menuTitle
        viewController.data = data
        navigationOption.navigate(viewController: viewController, navigator: navigator, animated: animated)
    }

    static func pop(viewController: UIViewController? = nil,
                    animated: Bool = true,
                    navigationOption: NavigationOption = .pop) {
        guard let navigator = (viewController ?? getTopMostViewController())?.navigationController else { return }
        guard let popViewController = viewController ?? navigator.viewControllers.last else { return }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            navigationOption.navigate(viewController: popViewController,
                                      navigator: navigator,
                                      animated: animated)
        }
    }

    private static func getViewController(from viewController: UIViewController,
                                          embedController: EmbedController) -> UIViewController {
        switch embedController {
        case .none:
            return viewController
        case .navigation:
            return BaseNC(rootViewController: viewController)
        }
    }

    static func getTopMostViewController() -> UIViewController? {
        UIApplication.shared.keyWindow?.topMostViewController()
    }

    static func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
