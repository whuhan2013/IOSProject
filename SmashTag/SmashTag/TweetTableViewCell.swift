//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by SchUser on 16/10/8.
//  Copyright © 2016年 SchUser. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    @IBOutlet weak var tweetScreenName: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
//     required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    var tweet:Tweet?{
        didSet{
            updateUI()
        }
    }
    

    
    
    func updateUI(){
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenName?.text = nil
        tweetProfileImageView?.image = nil
        //tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
            tweetScreenName?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                
                
                
                let qos = Int (QOS_CLASS_USER_INTERACTIVE.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                    let imageData=NSData(contentsOfURL:profileImageURL )
                    dispatch_async(dispatch_get_main_queue()){
                        if profileImageURL == tweet.user.profileImageURL{
                            if imageData != nil{
                                self.tweetProfileImageView?.image = UIImage(data: imageData!)
                            }else{
                                self.tweetProfileImageView?.image=nil
                            }
                        }
                    }
                })
                

//                if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
//                    tweetProfileImageView?.image = UIImage(data: imageData)
//                }
            }
                
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
//            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
            }
        
}
