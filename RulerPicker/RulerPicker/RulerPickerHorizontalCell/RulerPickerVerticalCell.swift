//
//  RulerPickerVerticalCell.swift
//  RulerPicker
//
//  Created by Александр on 05.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class RulerPickerHorizontalCell: RulerPickerCell {

    @IBOutlet private weak var selectionView: UIView!
    @IBOutlet private weak var valueLabel: UILabel!
    
    static let reuseID = String(describing: RulerPickerHorizontalCell.self)
    
    public override func setup(_ config: RulerPickerCellConfiguration?) {
        selectionView.backgroundColor = config?.color
        valueLabel.textColor = config?.labelColor
        valueLabel.font = config?.labelFont
    }
    
    public override func setup(_ text: String?) {
        valueLabel.isHidden = text == nil
        valueLabel.text = text
    }

}
