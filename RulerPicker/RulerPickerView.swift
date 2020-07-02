//
//  RulerPickerView.swift
//  RulerPicker
//
//  Created by Александр on 26.05.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import AudioToolbox

@objc class RulerPickerConfiguration: NSObject {
    var numberOfItems: Int = 0
    var direction: RulerDirection = .horizontal
    var selectionViewColor: UIColor = .red
}

@objc class RulerPickerCellConfiguration: NSObject {
    var color: UIColor = .lightGray
    var labelColor: UIColor = .lightGray
    var labelFont: UIFont = .systemFont(ofSize: 10)
    var labelAlignment: NSTextAlignment = .center
}

@objc class RulerPickerCell: UICollectionViewCell {

    private let horizontalContentView = UIView()
    private let horizontalSeparator = UIView()
    let horizontalLabel = UILabel()
    
    private let verticalContentView = UIView()
    private let verticalSeparator = UIView()
    let verticalLabel = UILabel()
    
    static let reuseID = String(describing: RulerPickerCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    public func setup(_ direction: RulerDirection, title: String?) {
        let label = direction == .horizontal ? horizontalLabel : verticalLabel
        label.isHidden = title == nil ? true : false
        label.text = title
        let isHidden = direction == .horizontal ? false : true
        horizontalContentView.isHidden = isHidden
        verticalContentView.isHidden = !isHidden
    }
    
    private func initialSetup() {
        horizontalContentView.frame = bounds
        horizontalSeparator.backgroundColor = .lightGray
        
        verticalContentView.frame = bounds
        verticalSeparator.backgroundColor = .lightGray
        
        horizontalLabel.textColor = .lightGray
        horizontalLabel.font = UIFont.systemFont(ofSize: 10)
        horizontalLabel.adjustsFontSizeToFitWidth = true
        horizontalLabel.textAlignment = .center
        
        verticalLabel.textColor = .lightGray
        verticalLabel.font = UIFont.systemFont(ofSize: 10)
        verticalLabel.adjustsFontSizeToFitWidth = true
        verticalLabel.textAlignment = .center
        
        addSubview(horizontalContentView)
//        addSubview(verticalContentView)
        
        horizontalContentView.addSubview(horizontalSeparator)
        horizontalContentView.addSubview(horizontalLabel)
        
//        verticalContentView.addSubview(verticalSeparator)
//        verticalContentView.addSubview(verticalLabel)
        
        horizontalSeparator.translatesAutoresizingMaskIntoConstraints = false
        horizontalLabel.translatesAutoresizingMaskIntoConstraints = false
//        horizontalContentView.translatesAutoresizingMaskIntoConstraints = false
        
//        verticalSeparator.translatesAutoresizingMaskIntoConstraints = false
//        verticalLabel.translatesAutoresizingMaskIntoConstraints = false
//        verticalContentView.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        horizontalContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        horizontalContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        horizontalContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        
        horizontalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -5).isActive = true
        horizontalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5).isActive = true
        horizontalLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        horizontalSeparator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        horizontalSeparator.bottomAnchor.constraint(equalTo: horizontalLabel.topAnchor, constant: 0).isActive = true
//        horizontalSeparator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        horizontalSeparator.leadingAnchor.constraint(equalTo: horizontalContentView.leadingAnchor, constant: 0).isActive = true
        horizontalSeparator.trailingAnchor.constraint(equalTo: horizontalContentView.trailingAnchor, constant: 0).isActive = true
        
        
//        verticalContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
//        verticalContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
//        verticalContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
//        verticalContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//
//        verticalSeparator.leadingAnchor.constraint(equalTo: verticalContentView.leadingAnchor, constant: 0).isActive = true
//        verticalSeparator.centerYAnchor.constraint(equalTo: verticalContentView.centerYAnchor, constant: 0).isActive = true
//        verticalSeparator.trailingAnchor.constraint(equalTo: verticalLabel.leadingAnchor, constant: 0).isActive = true
//
//        verticalLabel.trailingAnchor.constraint(equalTo: verticalContentView.trailingAnchor, constant: 0).isActive = true
    }
    
}

@objc protocol RulerPickerViewDelegate: class {
    @objc optional func rulerPicker(_ view: RulerPickerView, didSelectValueAt row: Int)
    @objc optional func rulerPicker(_ view: RulerPickerView, sizeFor row: Int) -> CGSize
}

@objc protocol RulerPickerViewDataSource: class {
    @objc func rulerPicker(_ view: RulerPickerView, titleFor indexPath: Int) -> String?
    @objc optional func rulerPicker(_ view: RulerPickerView, configurationFor indexPath: Int) -> RulerPickerCellConfiguration
}

enum RulerDirection {
    case vertical
    case horizontal
}

class RulerPickerView: UIView {
    
    private var collectionView: UICollectionView
    private var highlightView = UIView()
    private var lastOffsetWithSound: CGFloat = 0
    private var currentIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    public var configuration: RulerPickerConfiguration {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate: RulerPickerViewDelegate?
    weak var dataSource: RulerPickerViewDataSource?
    
    required init(config: RulerPickerConfiguration) {
        let layout = SnappingCollectionViewLayout()
        configuration = config
        layout.scrollDirection = configuration.direction == .horizontal ? .horizontal : .vertical
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
        collectionView.register(RulerPickerCell.self, forCellWithReuseIdentifier: RulerPickerCell.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .normal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        let viewHalf = configuration.direction == .horizontal ? bounds.width / 2 : bounds.height / 2
        let insets: UIEdgeInsets = configuration.direction == .horizontal ? UIEdgeInsets(top: 0, left: viewHalf, bottom: 0, right: viewHalf) : UIEdgeInsets(top: viewHalf, left: 0, bottom: viewHalf, right: 0)
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
            let row = indexPath.row// + 2
            
            if row % 10 == 0 {
                return CGSize(width: 3, height: collectionView.frame.height)
            } else if row % 10 == 5 {
                return CGSize(width: 3, height: collectionView.frame.height / 1.5)
            } else {
                return CGSize(width: 3, height: (collectionView.frame.height / 2) + 0.1)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RulerPickerCell.reuseID, for: indexPath) as? RulerPickerCell else { return UICollectionViewCell() }
        
        let title = dataSource?.rulerPicker(self, titleFor: indexPath.row)
        cell.setup(configuration.direction, title: title)
        
        return cell
    }
    
}

class SnappingCollectionViewLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment + 1, y: proposedContentOffset.y)
    }
}
