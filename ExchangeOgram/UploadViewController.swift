//
//  UploadViewController.swift
//  ExchangeOgram
//
//  Created by KEEVIN MITCHELL on 11/29/14.
//  Copyright (c) 2014 Beyond 2021. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var portraitImage: UIImageView!
    @IBOutlet weak var yourThoughtsLabel: UILabel!
    @IBOutlet weak var yourImageView: UIView!
    var phoneString = ""
    
    @IBOutlet weak var imageThoughts: UILabel!
    
    @IBAction func dismissViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true , completion: nil)
    }
    
    @IBAction func sendImage(sender: AnyObject) {
        //What we want to do is creater a Parse message object. It will be 2 parts message text and image itself.
        let message = PFObject(className: "Message")
        //The text portion of the messaage
        message["textContent"] = messageTextView.text
        //The image part of the message
        
        let image = UIImageJPEGRepresentation(imageView.image, 0.5)//Data representation of image
        let messageImage = PFFile(name: "image", data: image)//Special file to hold image
        
       // message["image"] = image
        //Saving
        //First we save the image. Notice the save with progress
        messageImage.saveInBackgroundWithBlock({ (success:Bool, error: NSError!) -> Void in
            //If we successfully saved the image .. check for success. We want to save the message image in the message object
            if success{
                message["messageImage"] = messageImage // cjoose to make  key "messageImage" in Message
                message.saveInBackgroundWithTarget(self, selector: nil)//Notice the new parse save in background. Here both the image and text are saved with each other
                
                //Next lets close this view controller
              self.dismissViewControllerAnimated(true , completion: nil)  
                
            }
            
            
            }, progressBlock: { (progress:Int32) -> Void in
               // progressBlock requires an Int32 but progressBar needs a float so conversion is needed.
                let progressFloat = Float(progress) / 100 // to get the float value
                //Set the progress
                self.progressView.setProgress(progressFloat, animated: true )
                
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UITapGestureRecognizer()
        recognizer.numberOfTapsRequired = 1
        portraitImage.addGestureRecognizer(recognizer)
        
        recognizer.addTarget(self, action: "displayImagePicker:")
        
      
        
        
    }
    
    
    //Herre we are passing in the tap itself to get the imgePicker// in viewDidLoad
    
    func displayImagePicker(recognizer:UITapGestureRecognizer){
        //first we want to display the imagepickercontroller
        let picker = UIImagePickerController()
        //we need the delegate methods to deyecy when the user has picked an image
        picker.delegate = self
        
        let actionSheet = UIAlertController(title: "Choose Image Scource", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                
                picker.sourceType = UIImagePickerControllerSourceType.Camera
                
                
                self.presentViewController(picker, animated: true, completion: nil)
                
                
            } else{
                let alertView = UIAlertController(title: "Idiot Alert!", message: "This is a fucking Alert and you are on the simulator fool", preferredStyle: UIAlertControllerStyle.Alert)
                alertView.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.presentViewController(alertView, animated: true, completion: nil)
                
                
            }
            
            
            
            
        }            ))
        
        
        actionSheet.addAction(UIAlertAction(title: "PhotoLibrary", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
            
            
        } ))
        
        
        actionSheet.addAction(UIAlertAction(title: "SavedPhotosAlbum", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            self.presentViewController(picker, animated: true, completion: nil)
            
        } ))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "batteryLevelChanged:", name: UIDeviceBatteryLevelDidChangeNotification, object: nil)
*/
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        
    }
    
    func deviceOrientationDidChange(sender: AnyObject?) {
       //  self.yourThoughtsLabel.alpha = 0
    }
    
    
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
    }
    
    
    
    
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        UIView.animateWithDuration(duration, animations: { () -> Void in
            
          //  self.yourThoughtsLabel.alpha = 0
            
        })
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillDisappear(animated: Bool) {
        /*
        - (void)deviceOrientationDidChange:(NSNotification *)notification {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        [self willRotateToInterfaceOrientation:orientation duration:1.0];
        }
        
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        
*/
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        
        
    }
    
    //MARK: Image picker controller Delegate
    //Lets do image picker did finish with media
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        //create an image and assign it the dictionary keyValue pairs by specifying the predefined key
        
        
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        
        
        //Here we change the content mode we set to center in storyboards
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        //Now We assign this image to our image view
        imageView.image = image
        //Dismiss the picker
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    

}
