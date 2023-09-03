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
        guard let audioPath = Bundle.main.url(forResource: "song", withExtension: "mp3") else { return nil }
        songs.append(audioPath)
        guard let audioPath1 = Bundle.main.url(forResource: "song1", withExtension: "mp3") else { return nil }
        songs.append(audioPath1)
        guard let audioPath2 = Bundle.main.url(forResource: "song2", withExtension: "mp3") else { return nil }
        songs.append(audioPath2)
        guard let audioPath3 = Bundle.main.url(forResource: "song3", withExtension: "mp3") else { return nil }
        songs.append(audioPath3)
        guard let audioPath4 = Bundle.main.url(forResource: "song4", withExtension: "mp3") else { return nil }
        songs.append(audioPath4)
        guard let audioPath5 = Bundle.main.url(forResource: "song5", withExtension: "mp3") else { return nil }
        songs.append(audioPath5)
        guard let audioPath6 = Bundle.main.url(forResource: "song6", withExtension: "mp3") else { return nil }
        songs.append(audioPath6)
        guard let audioPath7 = Bundle.main.url(forResource: "song7", withExtension: "mp3") else { return nil }
        songs.append(audioPath7)
        guard let audioPath8 = Bundle.main.url(forResource: "song8", withExtension: "mp3") else { return nil }
        songs.append(audioPath8)

        return songs
    }
}
