//
//  MainScreenViewModel.swift
//  NoamTest
//
//  Created by Noam Maydani on 2/4/22.
//

import Foundation
import Observable

enum MainScreenViewModelEvents {
    case reloadCollectionView
}

class MainScreenViewModel {
    
    enum prograssType {
        case loader
        case none
    }
    
    let eventsObserver = MutableObservable<MainScreenViewModelEvents?>(nil)
    let loaderObserver = MutableObservable<Bool>(false)
    private(set) var photos = [Photo]()
    private var currentPage = 1
    
    init() { fetchPhotos(with: .loader) }
    
    func fetchPhotos(with prograss: prograssType) {
        showPrograss(prograss: prograss)
        FlickrAPI.shared.getPhotos(page: currentPage) { [weak self] metaData in
            self?.endPrograss(prograss: prograss)
            self?.currentPage += 1
            self?.photos.append(contentsOf: metaData.photos.photo)
            self?.eventsObserver.wrappedValue = .reloadCollectionView
        }
    }
    
    private func showPrograss(prograss: prograssType) {
        switch prograss {
        case .loader: loaderObserver.wrappedValue = true
        case .none: break
        }
    }
    
    private func endPrograss(prograss: prograssType) {
        switch prograss {
        case .loader: loaderObserver.wrappedValue = false
        case .none: break
        }
    }
    
    func getPhotoURL(at index: Int) -> String {
        return "https://live.staticflickr.com/\(photos[index].server)/\(photos[index].id)_\(photos[index].secret).jpg"
    }
    
    func handlePaginationIfNeeded(at index: Int) {
        if photos.count - index == 15 {
            fetchPhotos(with: .none)
        }
    }
}
