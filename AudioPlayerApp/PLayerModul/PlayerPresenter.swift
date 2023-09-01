//
//  PlayerPresenter.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 31.08.2023.
//

import UIKit

protocol PlayerPresentationProtocol: AnyObject {
    var viewController: PlayerDisplayLogic? {get set}
    var router: PlayerRouterProtocol? {get set}
}

final class PlayerPresenter: PlayerPresentationProtocol {
    
    //MARK: - MVP Properties
    
    weak var viewController: PlayerDisplayLogic?
    var router: PlayerRouterProtocol?
    
    //MARK: - Network Service
    
    //MARK: - Init
    
    //MARK: - Data variables
    
    // MARK: - Delegate Methods
    
}

//MARK: - Private Methods

private extension PlayerPresenter {
    
}
