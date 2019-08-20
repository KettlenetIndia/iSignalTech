//
//  ISCustomMapAnnotation.swift
//  iSignal Tech
//
//  Created by Apple on 22/11/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import MapKit

class ISCustomMapAnnotation: MKAnnotationView {
    
    var annotationDetail : CategoryItem?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.image = #imageLiteral(resourceName: "ic_map_pin")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.image = #imageLiteral(resourceName: "ic_map_pin")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubviewToFront(self)
        }
        return hitView
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds;
        var isInside: Bool = rect.contains(point);
        if(!isInside)
        {
            for view in self.subviews
            {
                isInside = view.frame.contains(point);
                if isInside
                {
                    break;
                }
            }
        }
        return isInside;
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let hitView = super.hitTest(point, with: event)
//        if hitView != nil{
//            self.superview?.bringSubview(toFront: self)
//        }
//        return hitView
//    }
//
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        let rec = self.bounds
//        var isIn = rec.contains(point)
//        if !isIn{
//            for view in self.subviews{
//                isIn = view.frame.contains(point)
//                if isIn{
//                    break
//                }
//            }
//        }
//        return isIn
//    }
}


class CustomMapAnnotationPoint : MKPointAnnotation{
    var annotationDetail : CategoryItem?
}


class PopUpView : UIView{
    
    @IBOutlet weak var btnClick: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
}
