//
//  ContainerViewController.swift
//  SplitAndPopover
//
//  Created by KEEVIN MITCHELL on 12/10/14.
//  Copyright (c) 2014 Beyond 2021. All rights reserved.
//  This is going to be the rootviewcontroller and will embed the splitviewcontroller in it

import UIKit

class ContainerViewController: UIViewController {
    
    
    var viewController : UISplitViewController! //In this property we will assign later the split view controller that we have already added in the Interface Builder. 
    
    
    
    /*
    Next, we will implement a function which we will use to assign the split view controller to this viewController object. We can’t just do that directly, because when working with container view controllers there are specific steps that should be followed. These steps are described in detail in the official documentation by Apple (the link I gave you above), but they’re simple enough to be understood. Let’s see that function and then we’ll discuss a bit about it.
    As you see, the split view controller is passed as a parameter object to the above method. If it’s other than nil, then we assign it to the viewController object, and we perform the standard steps I talked about:
*/
    
    func setEmbeddedViewController(splitViewController: UISplitViewController!){
        if splitViewController != nil{
            viewController = splitViewController
            
            self.addChildViewController(viewController)
            self.view.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
            
           // self.setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular), forChildViewController: viewController)
            
        }
    }
    
    //overidinging the trait collection only in landscape mode
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        if size.width > size.height{
            self.setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular), forChildViewController: viewController)
        }
        else{
            self.setOverrideTraitCollection(nil, forChildViewController: viewController)
        }
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
