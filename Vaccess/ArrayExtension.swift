//
//  ArrayExtension.swift
//  Vaccess
//
//  Created by Extra Ryd on 2019-10-05.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func remove(_ element: Element) {
        _ = index(of: element).flatMap {
            self.remove(at: $0)
        }
    }
}
