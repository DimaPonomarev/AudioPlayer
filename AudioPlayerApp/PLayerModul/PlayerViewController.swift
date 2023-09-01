//
//  PlayerViewController.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 31.08.2023.
//


import UIKit
import AVFoundation
import SnapKit

protocol PlayerDisplayLogic: UIViewController {
    var presenter: PlayerPresentationProtocol? {get set}
}

final class PlayerViewController: UIViewController {
    
    //MARK: - MVP Properties
    
    var presenter: PlayerPresentationProtocol?
    
    //MARK: - UI properties
    
    let songNameLabel = UILabel()
    let artistNameLabel = UILabel()
    let trackLengthFromStartLabel = UILabel()
    let trackLenghtToTheEndLabel = UILabel()
    let previousTrackButton = UIButton()
    let nextTrackButton = UIButton()
    let playPauseButton = UIButton()
    let songDescriptionStackView = UIStackView()
    let songControlButtonsStackView = UIStackView()
    let progressViewOfSong = UIProgressView()
    
    //MARK: - Data variables
    
    var player: AVAudioPlayer?
    var position: Int = 0
    var playPauseFlag = true
    
    public var songs: [SongsList] = []
    
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        selfConfigurate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selfConfigurate()
    }
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
}
    
    //MARK: - Public Method
    


//MARK: - Private Methods

private extension PlayerViewController {
    
    // MARK: - Self configurate
    
    func selfConfigurate() {
        let assembly = PlayerAssembly()
        assembly.configurate(self)
    }
    
    //MARK: - setupUI
    
    func setupUI() {
        addViews()
        makeConstraints()
        setupViews()
        setupAction()
        makePlayer(song: songs[position])
    }
    
    //MARK: - addViews
    
    func addViews() {
        view.addSubview(songDescriptionStackView)
        songDescriptionStackView.addArrangedSubview(songNameLabel)
        songDescriptionStackView.addArrangedSubview(artistNameLabel)
        view.addSubview(trackLengthFromStartLabel)
        view.addSubview(trackLenghtToTheEndLabel)
        view.addSubview(songControlButtonsStackView)
        songControlButtonsStackView.addArrangedSubview(previousTrackButton)
        songControlButtonsStackView.addArrangedSubview(playPauseButton)
        songControlButtonsStackView.addArrangedSubview(nextTrackButton)
        view.addSubview(progressViewOfSong)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        songDescriptionStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(450)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        trackLengthFromStartLabel.snp.makeConstraints {
            $0.top.equalTo(songDescriptionStackView.snp.bottom).offset(30)
            $0.left.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        trackLenghtToTheEndLabel.snp.makeConstraints {
            $0.top.equalTo(songDescriptionStackView.snp.bottom).offset(30)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        progressViewOfSong.snp.makeConstraints {
            $0.top.equalTo(trackLengthFromStartLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(5)
        }
        
        songControlButtonsStackView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(progressViewOfSong.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
        }
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        setupNavBar()
        view.backgroundColor = .white
        
        songNameLabel.font = .systemFont(ofSize: 25)
        songNameLabel.numberOfLines = 2
        songNameLabel.textAlignment = .center
        
        artistNameLabel.font = .systemFont(ofSize: 20)
        artistNameLabel.textAlignment = .center
        
        trackLengthFromStartLabel.text = "20:20"
        trackLenghtToTheEndLabel.text = "20:20"
        
        songControlButtonsStackView.axis = .horizontal
        songControlButtonsStackView.spacing = 10
        songControlButtonsStackView.distribution = .fillProportionally

        songDescriptionStackView.axis = .vertical
        songDescriptionStackView.alignment = .center
        songDescriptionStackView.spacing = 10
        
        previousTrackButton.setImage(UIImage(named: "previous"), for: .normal)
        
        nextTrackButton.setImage(UIImage(named: "next"), for: .normal)
        
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
    }
    
    //MARK: - makePLayer
    
    func makePlayer(song: SongsList) {
        let song = songs[position]
        artistNameLabel.text = songs[position].artistName
        songNameLabel.text = songs[position].songName
        
        guard let url = song.urlPath else { return }
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.play()
        }
        catch {
            print("error ocurred")
        }
    }
    
    //MARK: - setupNavBar
    
    func setupNavBar() {
        
    }
    
    //MARK: - setupAction
    
    func setupAction() {
        playPauseButton.addTarget(self, action: #selector(clickPlayPause), for: .touchUpInside)
        previousTrackButton.addTarget(self, action: #selector(playPreviouseSong), for: .touchDown)
        nextTrackButton.addTarget(self, action: #selector(playNextSong), for: .touchDown)
    }
    
    //MARK: - objc method
    
    @objc func clickPlayPause() {
        switch playPauseFlag {
        case true:
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            player?.pause()
            playPauseFlag = false
        case false:
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            player?.play()
            playPauseFlag = true
            let d = Float(player?.duration ?? 0)
            progressViewOfSong.progress = 100
        }
    }
    
    @objc func playPreviouseSong() {
        if position > 0 {
            position -= 1
            makePlayer(song: songs[position])
        }
    }
    
    @objc func playNextSong() {
        if position != songs.count - 1 {
            position += 1
            makePlayer(song: songs[position])
        }
    }
    
    @objc func updateProgressView() {
        progressViewOfSong.progress = Float(player?.currentTime ?? 0)
        print(player?.duration)
    }
}

//MARK: - PlayerDisplayLogic extension

extension PlayerViewController: PlayerDisplayLogic {
    
}
