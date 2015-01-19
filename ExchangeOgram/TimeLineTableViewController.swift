//
//  TimeLineTableViewController.swift
//  ExchangeOgram
//
//  Created by KEEVIN MITCHELL on 12/4/14.
//  Copyright (c) 2014 Beyond 2021. All rights reserved.
//

import UIKit

class TimeLineTableViewController: PFQueryTableViewController {
    
    
    
    
    //First we start with an initializer initWithCode which is called at the very begining.
    required init(coder aDecoder: NSCoder) {
        //we then call super
        super.init(coder: aDecoder)
        
        //set the classname
        self.parseClassName = "Message"
        
        //We want to disply text content and image
        self.textKey = "textContent"
        self.imageKey = "messageImage"
        self.title = "Time Line"
        self.paginationEnabled = true
        self.objectsPerPage = 7
        
        
    }
    
    
    
    //this method is called as soon as the objects are loaded in the tableView
    override func objectsDidLoad(error: NSError!) {
        super.objectsDidLoad(error)
        //We want to check if this is an iPad. if this is an iPad or iPhone 6Plus we want to perform our segue to display the detaiViewController directly
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad || (UIDevice.currentDevice().userInterfaceIdiom == .Phone && UIScreen.mainScreen().bounds.width == 736){
            
            self.performSegueWithIdentifier("showDetail", sender: self)
        }
        
        
    }
    
    
    
    //now lets add a little performance enhancement
    
    override func queryForTable() -> PFQuery! {
        //Lets create a query
        let query = PFQuery(className: self.parseClassName)
        
        //if there are no objects in the cache then go to the network
        if self.objects.count == 0{
            query.cachePolicy = kPFCachePolicyCacheThenNetwork
            
        }
    query.orderByDescending("createdAt")
        
        
        
        return query
    }
    /*
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
    {
    static NSString *CellIdentifier = @"Cell";
    customPFTableCell *cell = (customPFTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
    //cell = [[customPFTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell = [[customPFTableCell alloc] init];
    //cell.reuseIdentifier = CellIdentifier;
    }
    
    cell.titleLabel.text = [object objectForKey:@"movieName"];
    cell.descLabel.text = [object objectForKey:@"movieSynopsis"];
    cell.leftImage.file = [object objectForKey:@"movieImage"];
    
    return cell;
    }

*/
    
    /*
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        return UITableViewCell()
    }
*/
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    
   
    //MARK: prepare data for tranfer
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //First we want to check if the cell is existing
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
           // if it exists check. have when page Line
            
            if cell.textLabel.text != "load more ..."{
              //We want to preform a segue
                self.performSegueWithIdentifier("showDetail", sender: self)
                
            }
            
            
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                
                let query = PFQuery(className: self.parseClassName)
              //  query.whereKey("textContent", equalTo: <#AnyObject!#>)
                
                
                
            
           // objects?.removeObjectAtIndex(indexPath.row)
            
          //  PFObject *object = [self.objects objectAtIndex.indexPath.row];
                //[object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
              //  [self loadObjects];
                
                
            let object = PFObject(className: self.parseClassName, dictionary: [self.textKey : "textContent",self.imageKey : "messageImage"])
                
                
               // self.objects.removeAtIndex(indexPath)
              
                
               // self.objects.deleteInBackgroundWithBlock({ (succeed:Bool, error:NSError?) -> Void in
                    self.loadObjects()
                  //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                           //     })
            
            
            
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
            
        }
    }
    
    
    
    
    

    //Since we are sending a segue we want to prepare our viewcontroller for it
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // first we check the segue identifier
        if segue.identifier == "showDetail" {
            //We want to create an indexpath and m,ake it optional and set it to nil. Top row
            var indexPath:NSIndexPath? = nil
            
            if self.tableView.indexPathForSelectedRow() == nil{
                //This is the top row
                indexPath = NSIndexPath(forRow: 0, inSection: 0)
                
            } else{
                indexPath = tableView.indexPathForSelectedRow()
                
            }
            //Now lets create a message to pass to the viewcontroller
            
            let message = self.objects[indexPath!.row] as PFObject // objects from PFQueryTableViewController
            
            //Next lets create our controller
           let detailViewController = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
            
            
            //let detailViewController = segue.destinationViewController as DetailViewController
            
            
            detailViewController.detailItem = message //passing the objecy in que for row
            
            detailViewController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            detailViewController.navigationItem.leftItemsSupplementBackButton = true
            
            
        }
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if size.width >= size.height{
            
            self.performSegueWithIdentifier("showDetail", sender: self)
            
        }
    }
    
    
    //MARK: Transitions
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    
    
}


