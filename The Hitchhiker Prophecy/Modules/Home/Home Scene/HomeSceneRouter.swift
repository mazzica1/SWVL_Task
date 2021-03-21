//
//  HomeSceneRouter.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Tarek on 6/15/20.
//  Copyright (c) 2020 SWVL. All rights reserved.
//

import UIKit

final class HomeSceneRouter: HomeSceneDataPassing {
    // MARK: - Stored properties
    weak var viewController: (HomeSceneDisplayView & UIViewController)?
    var dataStore: HomeSceneDataStore?
}

// MARK: - HomeSceneRoutingLogic Methods
extension HomeSceneRouter: HomeSceneRoutingLogic {
    func routeToCharacterDetailsWithCharacter(at index: Int) {
        guard let character = dataStore?.result?.results[index] else { return }
        let characterDetailsViewController = CharacterDetailsSceneConfigurator.configure(with: character)
        
        let transition = CATransition()
        transition.duration = 2.0
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        viewController?.navigationController?.view.layer.add(transition, forKey: nil)
        viewController?.navigationController?.pushViewController(characterDetailsViewController, animated: false)
        
    }
}
