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

protocol SongsListDisplayLogic: UIViewController {
    var presenter: SongsListPresentationProtocol? {get set}
}

class SongsListViewController: UIViewController, SongsListDisplayLogic {
    
    //MARK: - MVP Properties
    
    public var presenter: SongsListPresentationProtocol?
    
    //MARK: - UI properties
    
    private let tableView = UITableView()
    
    //MARK: - Data variables
    
    private var metadataOfAllSongs = [SongsList]()
    
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
        print(Bundle.main.url(forResource: "track2", withExtension: "mp3"))
    }
}

//MARK: - Private Methods

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

//MARK: - extension UITableViewDataSource, UITableViewDelegate


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
