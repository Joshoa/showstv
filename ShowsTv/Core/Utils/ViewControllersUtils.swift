//
//  ViewControllersUtils.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 15/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

extension UIViewController {
    
    func tryAuthenticate(onComplete: @escaping () -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Verify your identity!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        onComplete()
                    } else {
                        let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified! Please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    public func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgoundColor

            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title

        } else {
            navigationController?.navigationBar.barTintColor = backgoundColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.isTranslucent = false
            navigationItem.title = title
        }
    }
    
    public func configTabBar(selectedColor: UIColor, unselectedColor: UIColor = UIColor(named: "darkBlue")!, viewController: UIViewController) {
        
        let tabBar = viewController.tabBarController?.tabBar
        if let items = tabBar?.items {
            for item in items {
                
                if let image = item.image {
                    item.image = image.withRenderingMode(.alwaysOriginal).withTintColor(unselectedColor)
                    let unselectedItem = [NSAttributedString.Key.foregroundColor: unselectedColor]
                    item.setTitleTextAttributes(unselectedItem, for: .normal)
                }
                
                if let imageSelected = item.selectedImage {
                    item.selectedImage = imageSelected.withRenderingMode(.alwaysOriginal).withTintColor(selectedColor)
                    
                    let selectedItem = [NSAttributedString.Key.foregroundColor: selectedColor]
                    item.setTitleTextAttributes(selectedItem, for: .selected)
                }
                tabBar?.unselectedItemTintColor = unselectedColor
            }
        }
    }
}
