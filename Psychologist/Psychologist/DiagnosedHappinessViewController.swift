//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by SchUser on 16/10/5.
//  Copyright © 2016年 SchUser. All rights reserved.
//

import UIKit

class DiagnosedHappinessViewController: HappinessViewController ,UIPopoverPresentationControllerDelegate{
    
    override var happiness: Int{
        didSet{
            diagnosticHistory+=[happiness]
        }
    }
    
    private let defaults=NSUserDefaults.standardUserDefaults()
    
    var diagnosticHistory:[Int]{
        get{
            return defaults.objectForKey(History.DefaultKey) as? [Int] ?? []
        }
        set{
            defaults.setObject(newValue, forKey: History.DefaultKey)
        }
    }
    
    private struct History {
        static let SegueIndentifier="Show Diagnostic History"
        static let DefaultKey="DiagnosedHappinessViewController.History"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier=segue.identifier{
            switch identifier {
            case History.SegueIndentifier:
                if let tvc=segue.destinationViewController as? TextViewController{
                    if let ppc=tvc.popoverPresentationController{
                        ppc.delegate=self
                    }
                    
                    tvc.text="\(diagnosticHistory)"
                    
                }
            default:
                break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
}
