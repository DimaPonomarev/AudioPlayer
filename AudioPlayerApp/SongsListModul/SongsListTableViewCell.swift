//
//  SongsListTableViewCell.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 31.08.2023.
//

import UIKit
import SnapKit

class SongsListTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //MARK: - UI properties
    
    let songsName = UILabel()
    let songsDuration = UILabel()
    
    //MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configureView(_ model: SongsList) {


        songsName.text = "\(model.artistName!) - \(model.songName!)"
        songsDuration.text = model.duration
    }
}

//MARK: - Private methods

private extension SongsListTableViewCell {
    
    //MARK: - Setup
    
    func setup() {
        addViews()
        makeConstraints()
        
        
    }
    
    //MARK: - addViews
    
    func addViews() {
        contentView.addSubview(songsName)
        contentView.addSubview(songsDuration)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        songsName.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(20)
            $0.right.equalTo(songsDuration.snp.left).inset(-25)
        }
        songsDuration.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview().inset(20)
        }
    }
}
