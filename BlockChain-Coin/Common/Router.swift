//
//  Router.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

enum RoutingStyle {
    case push(navigationController: UINavigationController, presentedVC: UIViewController)
    case present(presentingVC: UIViewController, presentedVC: UIViewController)
}

protocol Router {
    func route(withStyle style: RoutingStyle, animated: Bool, completion: (() -> Void)?)
}

extension Router {
    func route(withStyle style: RoutingStyle, animated: Bool = true, completion: (() -> Void)? = nil) {
        switch style {
        case .push(let navigationController, let presentedVC):
            navigationController.pushViewController(presentedVC, animated: animated)
        case .present(let presentingVC, let presentedVC):
            presentingVC.present(presentedVC, animated: animated, completion: completion)
        }
    }
}
