//
//  MessageCell.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/8/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit

class AssignmentCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }


    
    /*override func didTransition(to state: UITableViewCell.StateMask) {
    super.willTransition(to: state)
        if state == .showingDeleteConfirmation {
        let deleteButton: UIView? = subviews.first(where: { (aView) -> Bool in
            return String(describing: aView).contains("Delete")

        })
        if deleteButton != nil {
            deleteButton?.frame.size.height = 90.0
        }
    
}



    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var subviews: [Any] = self.subviews
        let subview = subviews[0] as! UIView
        if subview.classForCoder.debugDescription() == "UITableViewCellDeleteConfirmationView" {
            subview.frame.size.height = 90
            subview.frame.origin.y = 10
            subview.clipsToBounds = true
            subview.layer.masksToBounds = true
        }

    }
    
}
