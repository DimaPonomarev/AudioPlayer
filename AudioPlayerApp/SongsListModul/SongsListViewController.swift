//
//  SongsListViewController.swift
//  AudioPlayerApp
//
//  Created by Дмитрий Пономарев on 31.08.2023.
//


import UIKit
import SnapKit
import AVFoundation
import MediaPlayer

//var songs: [SongsList] = [SongsList(artistName: "name", albumName: "album", artistName: "artist", imageName: "image", duration: "songs"),
//                          SongsList(artistName: "name1", albumName: "album1", artistName: "artist1", imageName: "image1", duration: "song")]


protocol SongsListDisplayLogic: UIViewController {
    var presenter: SongsListPresentationProtocol? {get set}
}

class SongsListViewController: UIViewController, SongsListDisplayLogic {
    
    //MARK: - MVP Properties
    
    var presenter: SongsListPresentationProtocol?
    
    var metadataOfAllSongs = [SongsList]()
    
    //MARK: - UI properties
    
    let tableView = UITableView()
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
        
    }
    
    // MARK: - Setup
    
    private func setup() {
        let assembly = SongsListAssembly()
        assembly.configurate(self)
    }
    
    //MARK: - View lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        addViews()
        makeConstraints()
        setupViews()
        getMetaDataToShowSongsOnScreen()
    }
}

private extension SongsListViewController {
    
    //MARK: - getMetaDataToShowSongsOnScreen

    func getMetaDataToShowSongsOnScreen() {
        Task {
            let metadata = await presenter?.getMetadataFromSong()
            guard let data = metadata else { return }
            metadataOfAllSongs = data
            tableView.reloadData()
        }
    }
    
    //MARK: - addViews
    
    func addViews() {
        view.addSubview(tableView)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - setupTableView
    
    func setupViews() {
        tableView.register(SongsListTableViewCell.self, forCellReuseIdentifier: SongsListTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SongsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        metadataOfAllSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongsListTableViewCell.identifier, for: indexPath) as? SongsListTableViewCell else { return UITableViewCell() }
        let model = metadataOfAllSongs[indexPath.row]
        cell.configureView(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.router?.showPlayerViewController(songs: metadataOfAllSongs, choosenSongPosition: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}









//MARK: - makePlayer

//        func makePlayerMetaData() async {
//
//            var info: SongsList = SongsList()
//            guard let listOfSongs = SourceOfSongs.songs else { return }
//            for eachSong in listOfSongs {
//
//                let audioAsset = AVURLAsset.init(url: eachSong, options: nil)
//                do {
//                    let meta = try await audioAsset.load(.metadata, .duration)
//                    info.duration = meta.1.seconds
//                    info.urlPath = eachSong
//
//                    meta.0.forEach { item in
//                        guard let key = item.commonKey,
//                              let value = item.value else { return }
//                        switch key.rawValue {
//                        case "artist": info.artistName = value as? String
//                        case "title" : info.songName = value as? String
//                        default: return
//                        }
//                    }
//                    self.myMetaData.append(info)
//                    self.tableView.reloadData()
//                }
//                catch {
//                    print("error to get metadata")
//                }
//            }
//        }
