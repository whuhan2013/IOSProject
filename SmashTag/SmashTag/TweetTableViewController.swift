//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by SchUser on 16/10/8.
//  Copyright © 2016年 SchUser. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController ,UITextFieldDelegate{
    
    var tweets = [[Tweet]]()
    var searchText:String? = "#stanford"{
        didSet{
            lastSuccessfulRequest=nil
            searchTextField.text=searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    
    
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate=self
            searchTextField.text=searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField{
            textField.resignFirstResponder()
            searchText=textField.text
        }
        return true
    }
    var lastSuccessfulRequest:TwitterRequest?
    var nextRequestToAttempt:TwitterRequest?{
        if lastSuccessfulRequest == nil{
            if self.searchText != nil {
                return TwitterRequest(search: searchText!, count: 100)
            }else{
                return nil
            }
        }else{
            return lastSuccessfulRequest?.requestForNewer
        }
    }
    
    func refresh(){
        
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
            }
    
    
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchText != nil{
            if let request = nextRequestToAttempt{
                request.fetchTweets{(newTweets)-> Void in
                    dispatch_async(dispatch_get_main_queue()){ () -> Void in
                        if newTweets.count>0{
                            self.tweets.insert(newTweets, atIndex: 0)
                            
                            self.tableView.reloadData()
                            sender?.endRefreshing()
                        }
                    }
                }
            }
        }else{
        sender?.endRefreshing()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight=tableView.rowHeight
        tableView.rowHeight=UITableViewAutomaticDimension
        refresh()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return tweets.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tweets[section].count
    }
    
    private struct StroyBoard{
        static let CellReuseIdentifier="Tweet"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCellWithIdentifier(StroyBoard.CellReuseIdentifier , forIndexPath: indexPath) as! TweetTableViewCell
        
        let tweet=tweets[indexPath.section][indexPath.row]
        cell.tweet=tweet
//        cell.textLabel?.text=tweet.text
//        cell.detailTextLabel?.text=tweet.user.name
        
        return cell
    }
}
