//
//  PlayerPresenter.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 31.08.2023.
//

import UIKit
import AVFAudio

protocol PlayerPresentationProtocol: AnyObject {
    var viewController: PlayerDisplayLogic? {get set}
    func makePlayer(songs: SongsList)
}

final class PlayerPresenter: PlayerPresentationProtocol {
    
    //MARK: - MVP Properties
    
    weak var viewController: PlayerDisplayLogic?
    
    //MARK: - Public Methods
    
    public func makePlayer(songs: SongsList) {
        viewController?.songNameLabel.text = songs.artistName
        viewController?.artistNameLabel.text = songs.songName
        guard let url = songs.urlPath else { return }
        do {
            viewController?.player = try AVAudioPlayer(contentsOf: url)
            guard let player = viewController?.player else { return }
            player.play()
        }
        catch {
            print("error ocurred")
        }
    }
}
