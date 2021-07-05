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

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    func getTimeIntervalFrom(_ date: Date) -> TimeInterval {
        return self.timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate
    }
}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        
        guard let numberOfDays = dateComponents([.day], from: fromDate, to: toDate).day else {
            return -1
        }
        return numberOfDays < 0 ? (numberOfDays * -1) : numberOfDays
        
//        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
//        return numberOfDays.day!
    }
}
