//
//  extensionDateFormatter.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 02.09.2023.
//

import Foundation

extension DateComponentsFormatter {
    func convertToPlayerTimer(value: TimeInterval) -> String {
        weak var formatter = self
        formatter?.allowedUnits = [.minute, .second ]
        formatter?.zeroFormattingBehavior = [.pad]
        formatter?.unitsStyle = .positional
        let formattedString = formatter?.string(from: TimeInterval(value))!
        return formattedString ?? ""
    }
}
