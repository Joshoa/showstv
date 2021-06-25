//
//  Utils.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 17/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func htmlAttributedString(colorHex: String) -> NSAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                display: flex;
                align-items: center;
                justify-content: space-around;
                text-align: justify;
                color: \(colorHex);
                font-family: -apple-system;
              }
            </style>
          </head>
          <body>
            \(self)
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
            ) else {
            return nil
        }

        return attributedString
    }
}
