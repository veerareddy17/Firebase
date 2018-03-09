//
//  FirebaseTVC.swift
//  FireBaseDB
//
//  Created by Vera on 18/12/1939 Saka.
//  Copyright © 1939 Vera. All rights reserved.
//

import UIKit

class FirebaseTVC: UITableViewCell {

    @IBOutlet weak var firebaseView: UIView!
    @IBOutlet weak var gendreLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
