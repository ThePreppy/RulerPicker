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
    let values: [Int] = Array(0...100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rulerPickerView.delegate = self
        rulerPickerView.dataSource = self
        let config = RulerPickerConfiguration()
        config.numberOfItems = values.count
        rulerPickerView.configuration = config
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rulerPickerView.toCenter(animated: true)
    }


}

extension ViewController: RulerPickerViewDelegate {
    func rulerPicker(_ view: RulerPickerView, didSelectValueAt row: Int) {
        valueLabel.text = "\(values[row])"
    }
}

extension ViewController: RulerPickerViewDataSource {
    
    func rulerPicker(_ view: RulerPickerView, titleFor row: Int) -> String? {
        if row % 10 == 0 {
            return "\(values[row])"
        }
        
        return nil
    }
    
}
