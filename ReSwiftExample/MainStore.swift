//
//  MainStore.swift
//  ReSwiftExample
//
//  Created by Marvin Böddeker on 11.10.18.
//  Copyright © 2018 Marvin Böddeker. All rights reserved.
//

import Foundation
import ReSwift


class MainStore {
    static let shared = MainStore()

    internal var reducers: Reducers
    public var store: Store<AppState>

    init() {
        self.reducers = Reducers()
        self.store = Store<AppState>(reducer: reducers.moneyReducer, state: nil)
    }
}
