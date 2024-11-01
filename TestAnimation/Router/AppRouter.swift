//
//  AppRouter.swift
//  TestAnimation
//
//  Created by Кизим Илья on 01.11.2024.
//

import UIKit

protocol Router {
    var navigationController: UINavigationController? { get set }
    func start()
    func routeTo(_ route: Route)
}

enum Route {
    case start
    case first
    case second
}

protocol Routing {
    var router: Router? { get set }
}

class MainRouter: Router {
    var navigationController: UINavigationController?

    func start() {
        routeTo(.start)
    }
    
    func routeTo(_ route: Route) {
        let viewController = createViewController(for: route)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func createViewController(for route: Route) -> UIViewController {
        switch route {
        case .start:
            var vc: UIViewController & Routing = StartViewController()
            vc.router = self
            return vc
        case .first:
            return FirstTaskViewController()
        case .second:
            return SecondTaskViewController()
        }
    }
}
