//
//  DetailViewController.swift
//  ExchangeOgram
//
//  Created by KEEVIN MITCHELL on 11/26/14.
//  Copyright (c) 2014 Beyond 2021. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  //  @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
   

    @IBOutlet weak var textView: UITextView!

    var detailItem: PFObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: PFObject = self.detailItem {
            //first we want to test if the textView is initialized
            if let textView = textView{
                textView.text = detail["textContent"] as? String
                        }
            
            let imageFile = detail["messageImage"] as PFFile
            //Here we do the reverse functionality from upload viewcontroller
            imageFile.getDataInBackgroundWithBlock({ (data:NSData!, error:NSError!) -> Void in
                
                if error == nil{
                   //if no error we want to create the image
                        let image = UIImage(data: data)
                    //Now that we have an image
                    self.imageView.image = image
                    
                    
                    
                }
                
                }, progressBlock: { (progress:Int32) -> Void in
                    
                    // progressBlock requires an Int32 but progressBar needs a float so conversion is needed.
               //     let progressFloat = Float(progress) / 100 // to get the float value
                    //Set the progress
                 //   self.progressView.setProgress(progressFloat, animated: true )
            })
            
            
                    }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.redColor()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

