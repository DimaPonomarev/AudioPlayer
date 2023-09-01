//
//  Second.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 31.08.2023.
//

import UIKit
import AVFoundation
import MediaPlayer

public enum DynamicAttribute {

    case duration
    case commonMetadata
    case metadata

    var key: String {
        switch self {
        case .duration            : return "duration"
        case .commonMetadata    : return "commonMetadata"
        case .metadata            : return "metadata"
        }
    }
}

public extension AVAsset {
    
    private func loadAttributeAsynchronously(_ attribute: DynamicAttribute, completion: (() -> Void)?) {
        self.loadValuesAsynchronously(forKeys: [attribute.key], completionHandler: completion)
    }
    
    private func loadedAttributeValue<T>(for attribute: DynamicAttribute) -> T? {
        var error : NSError?
        let status = self.statusOfValue(forKey: attribute.key, error: &error)
        if let error = error {
            print("Error loading asset value for key '\(attribute.key)': \(error)")
        }
        
        guard (status == .loaded) else {
            return nil
        }
        
        return self.value(forKey: attribute.key) as? T
    }
    
    func load(_ attribute: DynamicAttribute, completion: @escaping ((_ items: [AVMetadataItem]) -> Void)) {
        self.loadAttributeAsynchronously(attribute) {
            let metadataItems = self.loadedAttributeValue(for: attribute) as [AVMetadataItem]?
            DispatchQueue.main.async {
                completion(metadataItems ?? [])
            }
        }
    }
}

class SecondViewController: UIViewController {
    let urlString = Bundle.main.path(forResource: "song", ofType: "mp3")
    let audioPath = Bundle.main.url(forResource: "song", withExtension: "mp3")!


    var player:AVAudioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let playerItem1 = AVPlayerItem(url: audioPath)
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(string: urlString!)!)
            player.play()
            
            playerItem1.asset.load(.metadata) { items in
                for item in items {
                    if item.commonKey == nil{
                        continue
                    }
                    if let key = item.commonKey, let value = item.value {

                        if key.rawValue == "title" {
                            print(value)
                        }
                        if key.rawValue  == "artist" {
                            print(value)
                        }
                    }
                }
            }
        } catch {
            print("error")
        }
    }
}
