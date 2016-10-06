//
//  ViewController.swift
//  Autolayout
//
//  Created by SchUser on 16/10/5.
//  Copyright © 2016年 SchUser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var loginField: UITextField!
    

    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    var secure:Bool = false{
        didSet{
            updateUI()
        }
    }
    
    var loggedInUser:User? {
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        passwordField.secureTextEntry=secure
        passwordLabel.text=secure ? "Secure Password" : "Password"
        nameLabel.text=loggedInUser?.name
        companyLabel.text=loggedInUser?.company
        image=loggedInUser?.image
    }
    
    
    @IBAction func login() {
        loggedInUser=User.login(loginField.text ?? "", password: passwordField.text  ?? "")
    }

    @IBAction func toggleSecurity() {
        secure = !secure
    }
    
    var image:UIImage?{
        get{
            return imageView.image
        }
        
        set{
            imageView.image = newValue
            if let constrainedView = imageView {
                if let newImage = newValue { //设置约束
                    aspectRatioConstraint = NSLayoutConstraint(item: constrainedView, attribute: .Width, relatedBy: .Equal, toItem: constrainedView, attribute: .Height, multiplier: newImage.aspectRatio, constant:0)
                }else {
                    aspectRatioConstraint = nil
                }
            }
        }
    }
    //NSLayoutConstraint为所有约束的class
    var aspectRatioConstraint: NSLayoutConstraint? {
        willSet { //在未设置前清除已存在的约束
            if let existingConstraint = aspectRatioConstraint {
                view.removeConstraint(existingConstraint)
            }
        }
        didSet { //设置约束
            if let newConstraint = aspectRatioConstraint {
                view.addConstraint(newConstraint)
            }
        }
    }

}

extension User{
    var image:UIImage? {
        if let image=UIImage(named: login){
            return image
        }else{
            return UIImage(named: "unknow_user")
        }
        
    }
}

//保证图片宽高比与原图一致
extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}

