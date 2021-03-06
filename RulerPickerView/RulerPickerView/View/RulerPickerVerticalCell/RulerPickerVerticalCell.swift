//
//  RulerPickerHorizontalCell.swift
//  RulerPicker
//
//  Created by Александр on 05.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class RulerPickerVerticalCell: UICollectionViewCell {

    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    static let reuseID = String(describing: RulerPickerVerticalCell.self)
    
    public func setup(_ config: RulerPickerCellConfiguration?) {
        selectionView.backgroundColor = config?.color
        valueLabel.textColor = config?.labelColor
        valueLabel.font = config?.labelFont
    }
    
    public func setup(_ text: String?) {
        valueLabel.isHidden = text == nil
        valueLabel.text = text
    }

}
