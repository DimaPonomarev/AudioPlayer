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
    
    //MARK: - MVP Properties
    
    weak var presenter: SongsListPresentationProtocol?
    
    private var songPositionInPreviousePlayerVC: Int?
    private var previousePlayerVC: PlayerViewController?
    
    //MARK: - Public Methods
    
    //instantiate PlayerViewController
    
    func showPlayerViewController(songs: [SongsList], choosenSongPosition: Int ) {
        
        let playerVC = PlayerViewController()
        playerVC.songArray = songs
        playerVC.positionOfChoosenSong = choosenSongPosition
        
        playerVC.closure = { previouseVC, songPositionInPreviouseVC in
            self.songPositionInPreviousePlayerVC = songPositionInPreviouseVC
            self.previousePlayerVC = previouseVC as? PlayerViewController
        }
        
    //choose and present the right instance of PlayerViewController depending of which song has choosen
        
        switch songPositionInPreviousePlayerVC {
        case nil:
            presenter?.viewController?.present(playerVC, animated: true)
        case choosenSongPosition:
            presenter?.viewController?.present(previousePlayerVC!, animated: true)
        case .some:
            previousePlayerVC?.timer?.invalidate()
            previousePlayerVC?.player?.stop()
            presenter?.viewController?.present(playerVC, animated: true)
            
        }
    }
}
