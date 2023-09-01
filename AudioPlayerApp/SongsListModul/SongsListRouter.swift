//
//  SongsListRouter.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 31.08.2023.
//

import UIKit

protocol SongsListRouterProtocol: AnyObject {
    var presenter: SongsListPresentationProtocol? {get set}
    func showPlayerViewController(songs: [SongsList], choosenSongPosition: Int )
}

class SongsListRouter: SongsListRouterProtocol {
    weak var presenter: SongsListPresentationProtocol?
    
    func showPlayerViewController(songs: [SongsList], choosenSongPosition: Int ) {
        let playerVC = PlayerViewController()
        playerVC.songs = songs
        playerVC.position = choosenSongPosition
        presenter?.viewController?.present(playerVC, animated: true)
    }
}
