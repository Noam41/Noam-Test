//
//  ViewController.swift
//  NoamTest
//
//  Created by Noam Maydani on 2/4/22.
//

import UIKit
import Kingfisher
import Observable
import Lottie

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var animationView: AnimationView!
    
    private let storyboardIdentifier = "Main"
    private var viewModel: MainScreenViewModel!
    private var disposal = Disposal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        configCollectionView()
        addObservers()
    }

    private func addObservers() {
        viewModel.eventsObserver.observe { [weak self] event, _ in
            guard let event = event else { return }
            self?.handleEvent(event: event)
        }.add(to: &disposal)
        
        viewModel.loaderObserver.observe { [weak self] isInPrograss, _ in
            self?.handlePrograssState(isInPrograss: isInPrograss)
        }.add(to: &disposal)
    }
    
    private func handlePrograssState(isInPrograss: Bool) {
        if isInPrograss {
            animationView.play(completion: nil)
        } else {
            animationView.stop()
            animationView.isHidden = true
        }
        
    }
    
    private func handleEvent(event: MainScreenViewModelEvents) {
        switch event {
        case .reloadCollectionView: collectionView.reloadData()
        }
    }
    
    private func setupViewModel() {
        viewModel = MainScreenViewModel()
    }
    
    private func configCollectionView() {
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

//MARK: - collectionView delegate and data source

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        viewModel.handlePaginationIfNeeded(at: indexPath.row)
        guard let cell: PhotosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as? PhotosCollectionViewCell else { return UICollectionViewCell() }
        cell.setupUI(with: viewModel.getPhotoURL(at: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        guard let singlePhotoViewController = storyboard.instantiateViewController(withIdentifier: SinglePhotoViewController.identifier) as? SinglePhotoViewController else { return }
        singlePhotoViewController.photoUrl = viewModel.getPhotoURL(at: indexPath.row)
        navigationController?.pushViewController(singlePhotoViewController, animated: true)
    }
}
