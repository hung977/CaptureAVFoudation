//
//  ImagePreviewViewController.swift
//  AVFoudationExample
//
//  Created by admin on 8/3/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit

class ImagePreviewViewController : UIViewController {
    
    var capturedImage : UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didCapturePhoto(notification:)), name: .didCapturePhoto, object: nil)
    }
    @objc func didCapturePhoto(notification: Notification) {
        if let image = notification.object as? UIImage {
            imageView.image = image
        }
    }
}
