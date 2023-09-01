//
//  PlayerRouter.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 31.08.2023.
//

import UIKit

protocol PlayerRouterProtocol: AnyObject {
    var presenter: PlayerPresentationProtocol? {get set}
}

final class PlayerRouter: PlayerRouterProtocol {
    
    weak var presenter: PlayerPresentationProtocol?
}
