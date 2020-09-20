//
//  RulerPickerViewDelegate.swift
//  RulerPicker
//
//  Created by Александр on 05.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

@objc protocol RulerPickerViewDelegate: class {
    @objc optional func rulerPicker(_ view: RulerPickerView, didSelectValueAt row: Int)
    @objc optional func rulerPicker(_ view: RulerPickerView, sizeFor row: Int) -> CGSize
}
