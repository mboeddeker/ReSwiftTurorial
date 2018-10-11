//
//  ViewController.swift
//  ReSwiftExample
//
//  Created by Marvin Böddeker on 11.10.18.
//  Copyright © 2018 Marvin Böddeker. All rights reserved.
//

import UIKit
import ReSwift

class ViewController: UIViewController, StoreSubscriber {

    @IBOutlet weak var label: UILabel!

    var store: Store<AppState>?

    @IBAction func addHundred(_ sender: Any) {
        let action = IncreaseMoney(value: 100.0)
        store?.dispatch(action)
    }

    @IBAction func removeTwenty(_ sender: Any) {
        let action = DecreaseMoney(value: 20.0)
        store?.dispatch(action)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.store = MainStore.shared.store
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store?.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        store?.unsubscribe(self)
    }

    func newState(state: AppState) {
        label.text = "Money: \(state.money)"
    }
}

