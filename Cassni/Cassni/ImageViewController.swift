//
//  ImageViewController.swift
//  Cassni
//
//  Created by SchUser on 16/10/6.
//  Copyright © 2016年 SchUser. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController,UIScrollViewDelegate {
    
    var imageURL : NSURL?{
        didSet{
            image=nil
            if view.window != nil{
            fetchImage()
            }
        }
    }
    
    func fetchImage(){
        if let url=imageURL{
            spinner?.startAnimating()
            let qos = Int (QOS_CLASS_USER_INTERACTIVE.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                let imageData=NSData(contentsOfURL:url )
                dispatch_async(dispatch_get_main_queue()){
                    if url == self.imageURL{
                        if imageData != nil{
                            self.image = UIImage(data: imageData!)
                        }else{
                            self.image=nil
                        }
                    }
            }
            })
            
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView=UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate=self
            scrollView.minimumZoomScale=0.03
            scrollView.maximumZoomScale=1.0
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    private var image:UIImage?{
        get{
            return imageView.image
        }
        set{
            imageView.image=newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        
//        if image == nil{
//            imageURL = DemoURL.Stanford
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil{
            fetchImage()
        }
    }
}
