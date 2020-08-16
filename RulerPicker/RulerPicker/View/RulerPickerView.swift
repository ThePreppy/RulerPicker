//
//  RulerPickerView.swift
//  RulerPicker
//
//  Created by Александр on 26.05.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import AudioToolbox

@objc protocol RulerPickerViewDelegate: class {
    @objc optional func rulerPicker(_ view: RulerPickerView, didSelectValueAt row: Int)
    @objc optional func rulerPicker(_ view: RulerPickerView, sizeFor row: Int) -> CGSize
}

@objc protocol RulerPickerViewDataSource: class {
    @objc func rulerPicker(_ view: RulerPickerView, titleFor indexPath: Int) -> String?
    @objc optional func rulerPicker(_ view: RulerPickerView, configurationFor indexPath: Int) -> RulerPickerCellConfiguration
}

final class RulerPickerView: UIView {
    
    private var collectionView: UICollectionView
    private var highlightView = UIView()
    private var lastOffsetWithSound: CGFloat = 0
    private var currentIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    public var configuration: RulerPickerConfiguration {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak public var delegate: RulerPickerViewDelegate?
    weak var dataSource: RulerPickerViewDataSource?
    
    required init(config: RulerPickerConfiguration) {
        let layout = SnappingCollectionViewLayout()
        configuration = config
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: .zero)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        let layout = SnappingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        configuration = RulerPickerConfiguration()
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup() {
        collectionView.frame = bounds
        collectionView.register(UINib(nibName: RulerPickerHorizontalCell.reuseID, bundle: nil), forCellWithReuseIdentifier: RulerPickerHorizontalCell.reuseID)
        collectionView.register(UINib(nibName: RulerPickerHorizontalCell.reuseID, bundle: nil), forCellWithReuseIdentifier: RulerPickerHorizontalCell.reuseID)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .normal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        let viewHalf = bounds.width / 2
        let insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: viewHalf, bottom: 0, right: viewHalf)
        collectionView.contentInset = insets
        
        highlightView.frame.size = CGSize(width: 1, height: bounds.height)
        highlightView.frame.origin.x = viewHalf
        highlightView.backgroundColor = .red
        
        addSubview(highlightView)
        addSubview(collectionView)
        bringSubviewToFront(highlightView)
    }
    
    public func toCenter(animated: Bool) {
        let centerIndexPath = IndexPath(item: configuration.numberOfItems / 2, section: 0)
        collectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: animated)
    }
    
}

extension RulerPickerView: UICollectionViewDelegate {
    
    private func playSound() {
        guard configuration.isSoundOn else { return }
        
        var collectionCenter = collectionView.center
        collectionCenter = collectionView.convert(collectionCenter, from: collectionView.superview)
        let centerCellIndexPath = collectionView.indexPathForItem(at: collectionCenter)
        
        if centerCellIndexPath?.compare(self.currentIndexPath) != .orderedSame {
            AudioServicesPlaySystemSoundWithCompletion(1157, nil)
            currentIndexPath = centerCellIndexPath!
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = CGPoint(x: self.collectionView.center.x + self.collectionView.contentOffset.x,
                            y: self.collectionView.center.y + self.collectionView.contentOffset.y)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        playSound()
        delegate?.rulerPicker?(self, didSelectValueAt: indexPath.row)
    }
    
}

extension RulerPickerView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let size = delegate?.rulerPicker?(self, sizeFor: indexPath.row) else {
            let row = indexPath.row
            
            if row % 10 == 0 {
                return CGSize(width: 3, height: collectionView.frame.height)
            } else if row % 10 == 5 {
                return CGSize(width: 3, height: collectionView.frame.height / 1.5)
            } else {
                return CGSize(width: 3, height: collectionView.frame.height / 2 + 0.1)
            }
            
        }
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension RulerPickerView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configuration.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RulerPickerHorizontalCell.reuseID, for: indexPath) as? RulerPickerHorizontalCell
        
        let title = dataSource?.rulerPicker(self, titleFor: indexPath.row)
        let defaultConfig = RulerPickerCellConfiguration()
        let config = dataSource?.rulerPicker?(self, configurationFor: indexPath.row) ?? defaultConfig
        cell?.setup(config)
        cell?.setup(title)
        
        return cell ?? UICollectionViewCell()
    }
    
}
