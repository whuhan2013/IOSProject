//
//  ViewController.swift
//  Cassni
//
//  Created by SchUser on 16/10/6.
//  Copyright © 2016年 SchUser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ivc = segue.destinationViewController as? ImageViewController{
            if let identifier=segue.identifier{
                switch identifier {
                case "Earth":
                    ivc.imageURL=DemoURL.NASA.Earth
                    ivc.title="Earth"
                case "Saturn":
                    ivc.imageURL=DemoURL.NASA.Saturn
                    ivc.title="Saturn"
                case "Cassini":
                    ivc.imageURL=DemoURL.NASA.Cassini
                    ivc.title="Cassini"
                default:
                    break
                }
            }
        }
    }

}

