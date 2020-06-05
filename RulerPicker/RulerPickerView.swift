//
//  RulerPickerView.swift
//  RulerPicker
//
//  Created by Александр on 26.05.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class RulerPickerCell: UICollectionViewCell {
    
    let label = UILabel()
    private let view = UIView()
    
    static let reuseID = String(describing: RulerPickerCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup() {
        view.backgroundColor = .lightGray
        view.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        addSubview(view)
        addSubview(label)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -5).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: label.topAnchor, constant: 0).isActive = true
        view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
    }
    
}

protocol RulerPickerViewDelegate: class {
    func rulerPicker(_ view: RulerPickerView, didChange value: Int)
}

class RulerPickerView: UIView {
    
    private var collectionView: UICollectionView
    private var values = [Int]()
    private var highlightView = UIView()
    
    weak var delegate: RulerPickerViewDelegate?
    
    public var valuesRange: ClosedRange<Int> {
        get {
            guard !values.isEmpty else { return 0...0 }
            return values[0]...values.count - 1
        }
        set {
            values.removeAll()
            for value in newValue {
                values.append(value)
            }
            collectionView.reloadData()
            let centerIndexPath = IndexPath(item: values.count / 2, section: 0)
            collectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    override init(frame: CGRect) {
        let layout = SnappingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        let layout = SnappingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        
        let viewHalfWidth = frame.width / 2
        collectionView.contentInset = UIEdgeInsets(top: 0, left: viewHalfWidth, bottom: 0, right: viewHalfWidth)
        
        highlightView.frame.size = CGSize(width: 1, height: bounds.height)
        highlightView.frame.origin.x = viewHalfWidth
        highlightView.backgroundColor = .red
        
        addSubview(highlightView)
        addSubview(collectionView)
        bringSubviewToFront(highlightView)
    }
    
}

extension RulerPickerView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = CGPoint(x: self.collectionView.center.x + self.collectionView.contentOffset.x,
                            y: self.collectionView.center.y + self.collectionView.contentOffset.y)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        delegate?.rulerPicker(self, didChange: values[indexPath.row])
    }
    
}

extension RulerPickerView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if values[indexPath.row] % 10 == 0 {
            return CGSize(width: 10, height: collectionView.frame.height)
        } else if values[indexPath.row] % 10 == 5 {
            return CGSize(width: 10, height: collectionView.frame.height / 1.5)
        } else {
            return CGSize(width: 10, height: (collectionView.frame.height / 2) + 0.1)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension RulerPickerView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RulerPickerCell.reuseID, for: indexPath) as? RulerPickerCell else { return UICollectionViewCell() }
        
        let item = values[indexPath.row]
        cell.label.text = "\(item)"
        cell.label.isHidden = values[indexPath.row] % 10 == 0 ? false : true
        
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

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment + 5, y: proposedContentOffset.y)
    }
}
