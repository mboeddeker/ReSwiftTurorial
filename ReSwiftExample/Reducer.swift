//
//  Reducer.swift
//  ReSwiftExample
//
//  Created by Marvin Böddeker on 11.10.18.
//  Copyright © 2018 Marvin Böddeker. All rights reserved.
//

import Foundation
import ReSwift

struct Reducers {

    func moneyReducer(action: Action, state: AppState?) -> AppState {
        var state = state ?? AppState()

        switch action {
        case let action as IncreaseMoney:
            state.money += action.value
        case let action as DecreaseMoney:
            state.money -= action.value
        default:
            return state
        }

        return state
    }
}
