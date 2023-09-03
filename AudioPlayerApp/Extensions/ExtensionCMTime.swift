//
//  ExtensionCMTime.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 03.09.2023.
//

import Foundation
import AVFoundation

extension CMTime {
    
    var songsDurationString:String {
        let totalSeconds = CMTimeGetSeconds(self)
        let minutes: Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds: Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
