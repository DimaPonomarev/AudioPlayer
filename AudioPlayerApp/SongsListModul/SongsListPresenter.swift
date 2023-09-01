//
//  SongsListPresenter.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 31.08.2023.
//

import UIKit
import AVFoundation

protocol SongsListPresentationProtocol: AnyObject{
    var viewController: SongsListDisplayLogic? {get set}
    var router: SongsListRouterProtocol? {get set}
    func getMetadataFromSong() async -> [SongsList]?
}

class SongsListPresenter: SongsListPresentationProtocol {
    weak var viewController: SongsListDisplayLogic?
    var router: SongsListRouterProtocol?

    func getMetadataFromSong() async -> [SongsList]? {
        var metadataArrayForAllSongs = [SongsList]()
        guard let arrayOfSongs = SourceOfSongs.songs else { return nil }
        for eachSong in arrayOfSongs {
            
            let audioAsset = AVURLAsset.init(url: eachSong, options: nil)
            do {
                let metadataOfEachSong = try await audioAsset.load(.metadata, .duration)
                var instanceOfMetadataArray: SongsList = SongsList()
                instanceOfMetadataArray.duration = metadataOfEachSong.1.seconds
                instanceOfMetadataArray.urlPath = eachSong
                
                metadataOfEachSong.0.forEach { item in
                    guard let key = item.commonKey,
                          let value = item.value else { return }
                    switch key.rawValue {
                    case "artist": instanceOfMetadataArray.artistName = value as? String
                    case "title" : instanceOfMetadataArray.songName = value as? String
                    default: return
                    }
                }
                metadataArrayForAllSongs.append(instanceOfMetadataArray)
            }
            catch {
                print("error to get metadata")
            }
        }
        return metadataArrayForAllSongs
    }
}
