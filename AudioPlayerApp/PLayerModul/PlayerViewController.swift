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
    var player: AVAudioPlayer? {get set}
    var songNameLabel: UILabel {get set}
    var artistNameLabel: UILabel { get set }
}

final class PlayerViewController: UIViewController, PlayerDisplayLogic {
    
    //MARK: - MVP Properties
    
    public var presenter: PlayerPresentationProtocol?
    
    //MARK: - UI properties
    
    public var songNameLabel = UILabel()
    public var artistNameLabel = UILabel()
    private let passedTimeFromStartLabel = UILabel()
    private let timeLeftBeforeEndLabel = UILabel()
    private let previousTrackButton = UIButton()
    private let nextTrackButton = UIButton()
    private let playPauseButton = UIButton()
    private let songDescriptionStackView = UIStackView()
    private let songControlButtonsStackView = UIStackView()
    private let sliderOfSongsDuration = UISlider()
    private let buttonClose = UIButton()

    //MARK: - Data variables
    
    public var player: AVAudioPlayer?
    public var positionOfChoosenSong: Int = 0
    public var songArray: [SongsList] = []
    public var timer: Timer?
    var closure: ((UIViewController, Int) -> Void)?
    
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
    }
}

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
        presenter?.makePlayer(songs: songArray[positionOfChoosenSong])
    }
    
    //MARK: - addViews
    
    func addViews() {
        view.addSubview(buttonClose)
        view.addSubview(songDescriptionStackView)
        songDescriptionStackView.addArrangedSubview(songNameLabel)
        songDescriptionStackView.addArrangedSubview(artistNameLabel)
        view.addSubview(passedTimeFromStartLabel)
        view.addSubview(timeLeftBeforeEndLabel)
        view.addSubview(songControlButtonsStackView)
        songControlButtonsStackView.addArrangedSubview(previousTrackButton)
        songControlButtonsStackView.addArrangedSubview(playPauseButton)
        songControlButtonsStackView.addArrangedSubview(nextTrackButton)
        view.addSubview(sliderOfSongsDuration)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        songDescriptionStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(450)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        passedTimeFromStartLabel.snp.makeConstraints {
            $0.top.equalTo(songDescriptionStackView.snp.bottom).offset(30)
            $0.left.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        timeLeftBeforeEndLabel.snp.makeConstraints {
            $0.top.equalTo(songDescriptionStackView.snp.bottom).offset(30)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        sliderOfSongsDuration.snp.makeConstraints {
            $0.top.equalTo(passedTimeFromStartLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(5)
        }
        songControlButtonsStackView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(sliderOfSongsDuration.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
        }
        buttonClose.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        view.backgroundColor = .white
        
        songNameLabel.font = .systemFont(ofSize: 25)
        songNameLabel.numberOfLines = 2
        songNameLabel.textAlignment = .center
        
        artistNameLabel.font = .systemFont(ofSize: 20)
        artistNameLabel.textAlignment = .center
                
        songControlButtonsStackView.axis = .horizontal
        songControlButtonsStackView.spacing = 10
        songControlButtonsStackView.distribution = .fillProportionally

        songDescriptionStackView.axis = .vertical
        songDescriptionStackView.alignment = .center
        songDescriptionStackView.spacing = 10

        previousTrackButton.setImage(UIImage(named: "previous"), for: .normal)
        nextTrackButton.setImage(UIImage(named: "next"), for: .normal)
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        
        sliderOfSongsDuration.isContinuous = true
        sliderOfSongsDuration.isUserInteractionEnabled = true

        buttonClose.setTitle("Close", for: .normal)
        buttonClose.setTitleColor(.systemBlue, for: .normal)
    }
    
    //MARK: - setupAction
    
    func setupAction() {
        buttonClose.addTarget(self, action: #selector(closePlayer), for: .touchDown)
        playPauseButton.addTarget(self, action: #selector(clickPlayOrPause), for: .touchUpInside)
        previousTrackButton.addTarget(self, action: #selector(playPreviouseSong), for: .touchDown)
        nextTrackButton.addTarget(self, action: #selector(playNextSong), for: .touchDown)
        sliderOfSongsDuration.addTarget(self, action: #selector(changePlayerTime), for: .valueChanged)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(makeAutomaticChangingSlider), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    //MARK: - objc methods
    
    @objc func closePlayer() {
        closure?(self, positionOfChoosenSong)
        dismiss(animated: true)
    }
    
    @objc func clickPlayOrPause() {
        if player?.isPlaying == true {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            player?.pause()
        } else {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            player?.play()
        }
    }
    
    @objc func playPreviouseSong() {
        if positionOfChoosenSong > 0 {
            positionOfChoosenSong -= 1
            presenter?.makePlayer(songs: songArray[positionOfChoosenSong])
        }
    }
    
    @objc func playNextSong() {
        if positionOfChoosenSong != songArray.count - 1 {
            positionOfChoosenSong += 1
            presenter?.makePlayer(songs: songArray[positionOfChoosenSong])
        } else {
            presenter?.makePlayer(songs: songArray[0])
            positionOfChoosenSong = 0
        }
    }
    
    @objc func makeAutomaticChangingSlider() {
        guard let duration = player?.duration else { return }
        guard let currentTime = player?.currentTime else { return }
        sliderOfSongsDuration.thumbTintColor = .clear
        sliderOfSongsDuration.maximumValue = Float(duration)
        sliderOfSongsDuration.value = Float(currentTime)
        let songsDuration = Int(duration)
        let currentTimeInt = Int(currentTime)
        passedTimeFromStartLabel.text = DateComponentsFormatter().convertToPlayerTimer(value: TimeInterval(currentTimeInt))
        timeLeftBeforeEndLabel.text = DateComponentsFormatter().convertToPlayerTimer(value: TimeInterval(songsDuration))
        
        if timeLeftBeforeEndLabel.text == "00:00" {
            playNextSong()
        }
    }
    
    @objc func changePlayerTime() {
        sliderOfSongsDuration.thumbTintColor = .white
        player?.pause()
        player?.currentTime = TimeInterval(sliderOfSongsDuration.value)
        player?.prepareToPlay()
        player?.play()
    }
}
