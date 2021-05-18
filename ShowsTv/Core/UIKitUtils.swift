//
//  UIKitUtils.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 16/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    func setupSearchBar(background: UIColor = .white, inputText: UIColor = .black, placeholderText: UIColor = .gray, image: UIColor = .black) {

        self.searchTextField.backgroundColor = background
        
        // Change placeholder color
        if #available(iOS 13.0, *) {
            let placeholder = NSAttributedString(string: "Search",
                                                 attributes: [
                                                    .foregroundColor: placeholderText
            ])
            let searchTextField = self.searchTextField
            searchTextField.tintColor = placeholderText

            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    searchTextField.attributedPlaceholder = placeholder
                }
            }
        }

        //  Change Image Color
        if let leftView = self.searchTextField.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = image
        }
    }
}

extension UITableViewCell {
    func setDisclosureArrow(size: CGFloat, color: UIColor) {
        self.tintColor = color
        let image = UIImage(named: "disclosureArrow")?.withRenderingMode(.alwaysTemplate)
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width: size, height: size));
        checkmark.image = image
        self.accessoryView = checkmark
    }
}

extension UIViewController {
    func changeSearchBarInputForegroundColor(_ color: UIColor) {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: color]
    }
}
