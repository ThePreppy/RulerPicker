//
//  RulerPickerCellConfiguration.swift
//  RulerPicker
//
//  Created by Александр on 05.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

@objc final class RulerPickerCellConfiguration: NSObject {
    var color: UIColor = .lightGray
    var labelColor: UIColor = .lightGray
    var labelFont: UIFont = .systemFont(ofSize: 10)
    var labelAlignment: NSTextAlignment = .center
}
