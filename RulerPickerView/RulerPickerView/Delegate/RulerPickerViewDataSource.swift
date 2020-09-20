//
//  RulerPickerViewDataSource.swift
//  RulerPicker
//
//  Created by Александр on 20.09.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation

@objc protocol RulerPickerViewDataSource: class {
    @objc func rulerPicker(_ view: RulerPickerView, titleFor indexPath: Int) -> String?
    @objc optional func rulerPicker(_ view: RulerPickerView, configurationFor indexPath: Int) -> RulerPickerCellConfiguration
}
