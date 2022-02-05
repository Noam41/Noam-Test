//
//  SinglePhotoViewController.swift
//  NoamTest
//
//  Created by Noam Maydani on 2/5/22.
//

import UIKit

class SinglePhotoViewController: UIViewController {
    static var identifier = "SinglePhotoViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    var photoUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configImageView()
    }
    
    private func configImageView() {
        imageView.kf.setImage(with: URL(string: photoUrl ?? ""), placeholder: nil)
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
