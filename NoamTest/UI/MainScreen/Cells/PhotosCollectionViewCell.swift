//
//  PhotosCollectionViewCell.swift
//  NoamTest
//
//  Created by Noam Maydani on 2/5/22.
//

import UIKit
import Kingfisher

class PhotosCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "PhotosCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configImageView() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.frame
    }
    
    func setupUI(with url: String) {
        imageView.kf.setImage(with: URL(string: url), placeholder: nil)
    }
}
