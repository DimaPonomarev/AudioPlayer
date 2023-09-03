//
//  PlayerAssembly.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 31.08.2023.
//

import UIKit

final class PlayerAssembly {
    
    func configurate(_ vc: PlayerDisplayLogic) {
        let presenter = PlayerPresenter()
        vc.presenter = presenter
        presenter.viewController = vc
    }
}
