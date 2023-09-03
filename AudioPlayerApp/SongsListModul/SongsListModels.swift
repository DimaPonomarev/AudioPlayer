//
//  SongsListModels.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 31.08.2023.
//

import UIKit

struct SongsList {
    var songName: String?
    var urlPath: URL?
    var artistName: String?
    var duration: String?
}

class SourceOfSongs {
    static var songs: [URL]? {
        var songs = [URL]()
        guard let audioPath = Bundle.main.url(forResource: "track", withExtension: "mp3") else { return nil}
        songs.append(audioPath)
        guard let audioPath1 = Bundle.main.url(forResource: "track1", withExtension: "mp3") else { return nil }
        songs.append(audioPath1)
        guard let audioPath2 = Bundle.main.url(forResource: "track2", withExtension: "mp3") else { return nil }
        songs.append(audioPath2)
        guard let audioPath3 = Bundle.main.url(forResource: "track3", withExtension: "mp3") else { return nil }
        songs.append(audioPath3)
        guard let audioPath4 = Bundle.main.url(forResource: "track4", withExtension: "mp3") else { return nil }
        songs.append(audioPath4)
        guard let audioPath5 = Bundle.main.url(forResource: "track5", withExtension: "mp3") else { return nil }
        songs.append(audioPath5)
        guard let audioPath6 = Bundle.main.url(forResource: "track6", withExtension: "mp3") else { return nil }
        songs.append(audioPath6)
        return songs
    }
}
