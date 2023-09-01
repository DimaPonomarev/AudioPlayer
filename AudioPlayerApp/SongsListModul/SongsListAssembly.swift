//
//  SongsListAssembly.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 31.08.2023.
//

import UIKit

final class SongsListAssembly{
    func configurate(_ vc: SongsListDisplayLogic) {
        let presenter = SongsListPresenter()
        let router = SongsListRouter()
        vc.presenter = presenter
        presenter.viewController = vc
        presenter.router = router
        router.presenter = presenter
    }
}
