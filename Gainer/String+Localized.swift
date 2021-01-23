//
//  String+Localized.swift
//  Gainer
//
//  Created by आश्विन पौडेल  on 2021-01-22.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
