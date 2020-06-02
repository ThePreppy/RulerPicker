//
//  ViewController.swift
//  RullerPicker
//
//  Created by Александр on 26.05.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var rullerPickerView: RullerPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rullerPickerView.delegate = self
        rullerPickerView.valuesRange = 0...100
    }


}

extension ViewController: RullerPickerViewDelegate {
    func rullerPicker(_ view: RullerPickerView, didChange value: Int) {
        valueLabel.text = "\(value)"
    }
}

