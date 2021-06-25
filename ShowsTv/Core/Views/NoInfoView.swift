//
//  NoInfoView.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 18/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation
import UIKit

class NoInfoView: UIStackView {
    @IBOutlet weak var lbText: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    public func config(_ text: String, color: UIColor, image: UIImage) {
        lbText.text = text
        lbText.textColor = color
        self.image.image = image
    }
    
    public func setText(_ text: String) {
        lbText.text = text
    }
    
    public class func initializeFromNib() -> NoInfoView {
       return UINib(nibName: "NoInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as! NoInfoView
    }
}
