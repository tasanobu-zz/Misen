//
//  ViewController.swift
//  Sample
//
//  Created by Kazunobu Tasaka on 8/8/15.
//  Copyright (c) 2015 Kazunobu Tasaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cameraImageView: UIImageView! {
        didSet {
            cameraImageView.image = ImageAsset.camera.image
        }
    }
    
    @IBOutlet weak var contactImageView: UIImageView! {
        didSet {
            contactImageView.image = ImageAsset.contact.image
        }
    }
    
    @IBOutlet weak var homeImageView: UIImageView! {
        didSet {
            homeImageView.image = UIImage(assetName: .home)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

