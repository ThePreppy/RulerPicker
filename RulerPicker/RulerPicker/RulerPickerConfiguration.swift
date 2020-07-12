//
//  RulerPickerConfiguration.swift
//  RulerPicker
//
//  Created by Александр on 05.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

@objc class RulerPickerConfiguration: NSObject {
    var numberOfItems: Int = 0
    var direction: RulerDirection = .horizontal
    var selectionViewColor: UIColor = .red
    var isSoundOn = true
}
