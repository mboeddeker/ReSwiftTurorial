//
//  Actions.swift
//  ReSwiftExample
//
//  Created by Marvin Böddeker on 11.10.18.
//  Copyright © 2018 Marvin Böddeker. All rights reserved.
//

import Foundation
import ReSwift

struct IncreaseMoney: Action {
    var value: Float

    init(value: Float) {
        self.value = value
    }
}

struct DecreaseMoney: Action {
    var value: Float

    init(value: Float) {
        self.value = value
    }
}


