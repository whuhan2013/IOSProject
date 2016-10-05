//
//  TextViewController.swift
//  Psychologist
//
//  Created by SchUser on 16/10/5.
//  Copyright © 2016年 SchUser. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.text=text
        }
    }
    
    var text:String=""{
        didSet{
            textView?.text=text
        }
    }
    
    
    override var preferredContentSize: CGSize{
        get{
            if textView != nil && presentingViewController != nil {
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            }else{
                return super.preferredContentSize
            }
        }
        set{
            super.preferredContentSize=newValue
        }
    }
}
