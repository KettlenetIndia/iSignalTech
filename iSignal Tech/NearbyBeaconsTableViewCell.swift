//
//  NearbyBeaconsTableViewCell.swift
//  iSignal Tech
//
//  Created by Salman Maredia on 27/05/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit

class NearbyBeaconsTableViewCell: UITableViewCell {

    @IBOutlet weak var beaconName: UILabel!
    @IBOutlet weak var beaconDistance: UILabel!
    @IBOutlet weak var viewOfferBtn: UIButton!
    
    override func layoutSubviews() {
        
        viewOfferBtn.layer.cornerRadius = 15
    }
}
