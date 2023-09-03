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
    
    //MARK: - MVP Properties

    weak var viewController: SongsListDisplayLogic?
    var router: SongsListRouterProtocol?
    
    //MARK: - Public Methods
    //convert metadata to SongsList model and pass to SongListViewController

    public func getMetadataFromSong() async -> [SongsList]? {
        var metadataArrayForAllSongs = [SongsList]()
        guard let arrayOfSongs = SourceOfSongs.songs else { return nil }
        for eachSong in arrayOfSongs {
            let audioAsset = AVURLAsset.init(url: eachSong, options: nil)
            do {
                let metadataOfEachSong = try await audioAsset.load(.metadata, .duration)
                var instanceOfMetadataArray: SongsList = SongsList()
                instanceOfMetadataArray.duration = metadataOfEachSong.1.songsDurationString
                instanceOfMetadataArray.urlPath = eachSong
                
                metadataOfEachSong.0.forEach { metadata in
                    guard let key = metadata.commonKey,
                          let value = metadata.value else { return }
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
