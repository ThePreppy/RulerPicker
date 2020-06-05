//
//  ViewController.swift
//  RulerPicker
//
//  Created by Александр on 26.05.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var rulerPickerView: RulerPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rulerPickerView.delegate = self
        rulerPickerView.valuesRange = 0...100
    }


}

extension ViewController: RulerPickerViewDelegate {
    func rulerPicker(_ view: RulerPickerView, didChange value: Int) {
        valueLabel.text = "\(value)"
    }
}

