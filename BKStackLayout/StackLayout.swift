//
//  StackLayout.swift
//  BKStackLayout
//
//  Created by burt on 2018. 11. 4..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit
#else
import Cocoa
#endif

#if os(iOS)
public typealias SLView = UIView
public typealias SLStackView = UIStackView
public typealias SLColor = UIColor
public typealias SLEdgeInsets = UIEdgeInsets
public typealias SLLayoutPriority = UILayoutPriority
public typealias SLAlignment = UIStackView.Alignment
public typealias SLScreen = UIScreen
#else
public typealias SLView = NSView
public typealias SLStackView = NSStackView
public typealias SLColor = NSColor
public typealias SLEdgeInsets = NSEdgeInsets
public typealias SLLayoutPriority = NSLayoutPriority
public typealias SLAlignment = NSLayoutConstraint.Attribute
public typealias SLScreen = NSScreen
#endif

fileprivate protocol StackLayoutUpdatable {
    func update()
}

fileprivate protocol StackLayoutStretchable {
}

fileprivate class StackSpacingView: SLView {
    private let size: CGSize
    
    init(width: CGFloat, height: CGFloat) {
        self.size = CGSize(width: width, height: height)
        super.init(frame: .zero)
    }
    
    override var intrinsicContentSize: CGSize {
        return size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class StackFixedSpacingView: StackSpacingView {
}

fileprivate class StackFlexSpacingView: StackSpacingView, StackLayoutStretchable {
}

fileprivate class StackWrapView: SLView, StackLayoutUpdatable {
    private var size: CGSize
    private weak var contentView: SLView?
    
    init(view: SLView, width: CGFloat, height: CGFloat) {
        let w = width == 1 ? view.intrinsicContentSize.width : width
        let h = height == 1 ? view.intrinsicContentSize.height : height
        self.size = CGSize(width: w, height: h)
        super.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        self.contentView = view
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
    }
    
    override var intrinsicContentSize: CGSize {
        return size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        guard let contentView = contentView else { return }
        self.size = contentView.intrinsicContentSize
        self.isHidden = self.size == .zero
    }
}


public class StackLayout: SLView, StackLayoutUpdatable {
    
    enum Orientation {
        case vertical
        case horizontal
        
        fileprivate var toAxis: NSLayoutConstraint.Axis {
            switch self {
            case .vertical:
                return .vertical
            case .horizontal:
                return .horizontal
            }
        }
    }
    
    public enum VerticalAlignment {
        case top
        case center
        case bottom
        case fill
        case firstBaseline
        case lastBaseline
        
        fileprivate var toAlignment: SLAlignment {
            switch self {
            case .top:
                return .top
            case .center:
                return .center
            case .bottom:
                return .bottom
            case .fill:
                return .fill
            case .firstBaseline:
                return .firstBaseline
            case .lastBaseline:
                return .lastBaseline
            }
        }
    }
    
    public enum HorizontalAlignment {
        case left
        case center
        case right
        case fill
        
        fileprivate var toAlignment: SLAlignment {
            switch self {
            case .left:
                return .leading
            case .center:
                return .center
            case .right:
                return .trailing
            case .fill:
                return .fill
            }
        }
    }
    
    public enum Distribution {
        case fill
        case fillEqually
        case fillProportionally
        case equalSpacing
        case equalCentering
        
        fileprivate var toDistribution: SLStackView.Distribution {
            switch self {
            case .fill:
                return .fill
            case .fillEqually:
                return .fillEqually
            case .fillProportionally:
                return .fillProportionally
            case .equalSpacing:
                return .equalSpacing
            case .equalCentering:
                return .equalCentering
            }
        }
    }
    
    private var layoutViews: [SLView] = []
    private var orientation: Orientation = .vertical
    private var verticalAlignment: VerticalAlignment = .top
    private var horizontalAlignment: HorizontalAlignment = .left
    private var distribution: Distribution = .fill
    private var spacing: CGFloat = 0
    private var stackView: SLStackView? = nil
    private var marginLeft: CGFloat = 0
    private var marginRight: CGFloat = 0
    private var marginTop: CGFloat = 0
    private var marginBottom: CGFloat = 0
    
    public override var intrinsicContentSize: CGSize {
        guard let stackView = stackView else { return .zero }
        return stackView.intrinsicContentSize
    }
    
    @discardableResult
    public static func vertical(layout: (StackLayout) -> Swift.Void) -> StackLayout {
        let stackLayout = StackLayout()
        stackLayout.orientation = .vertical
        layout(stackLayout)
        stackLayout.build()
        return stackLayout
    }
    
    @discardableResult
    public func vertical(layout: (StackLayout) -> Swift.Void) -> StackLayout {
        let stackLayout = StackLayout()
        stackLayout.orientation = .vertical
        layout(stackLayout)
        stackLayout.build()
        self.layoutViews.append(stackLayout)
        return stackLayout
    }
    
    @discardableResult
    public static func horizontal(layout: (StackLayout) -> Swift.Void) -> StackLayout {
        let stackLayout = StackLayout()
        stackLayout.orientation = .horizontal
        layout(stackLayout)
        stackLayout.build()
        return stackLayout
    }
    
    @discardableResult
    public func horizontal(layout: (StackLayout) -> Swift.Void) -> StackLayout {
        let stackLayout = StackLayout()
        stackLayout.orientation = .horizontal
        layout(stackLayout)
        stackLayout.build()
        self.layoutViews.append(stackLayout)
        return stackLayout
    }
}

extension StackLayout {
    
    @discardableResult
    public func add(views: [SLView]) -> StackLayout {
        self.layoutViews = views
        self.layoutViews.filter { $0 is StackLayoutStretchable == false }.forEach {
            $0.setContentCompressionResistancePriority(SLLayoutPriority(rawValue: 1000), for: orientation == .vertical ? .vertical : .horizontal)
        }
        return self
    }
    
    public func flex(bgColor: SLColor = .clear) -> SLView {
        let width = orientation == .vertical ? 1 : SLScreen.main.bounds.width
        let height = orientation == .vertical ? SLScreen.main.bounds.height : 1
        let v = StackFlexSpacingView(width: width, height: height)
        v.backgroundColor = bgColor
        v.setContentCompressionResistancePriority(SLLayoutPriority(rawValue: 999), for: orientation == .vertical ? .vertical : .horizontal)
        return v
    }
    
    public func fixed(w width: CGFloat = 1, h height: CGFloat = 1, bgColor: SLColor = .clear) -> SLView {
        let v = StackFixedSpacingView(width: width, height: height)
        v.backgroundColor = bgColor
        return v
    }
    
    public func wrap(_ view: SLView, w width: CGFloat = 1, h height: CGFloat = 1, bgColor: SLColor = .clear) -> SLView {
        let v = StackWrapView(view: view, width: width, height: height)
        v.backgroundColor = bgColor
        return v
    }
}

extension StackLayout {
    @discardableResult
    public func spacing(_ value: CGFloat) -> StackLayout {
        self.spacing = value
        return self
    }
}

extension StackLayout {
    @discardableResult
    public func margin(left value: CGFloat) -> StackLayout {
        self.marginLeft = value
        return self
    }
    
    @discardableResult
    public func margin(right value: CGFloat) -> StackLayout {
        self.marginRight = value
        return self
    }
    
    @discardableResult
    public func margin(top value: CGFloat) -> StackLayout {
        self.marginTop = value
        return self
    }
    
    @discardableResult
    public func margin(bottom value: CGFloat) -> StackLayout {
        self.marginBottom = value
        return self
    }
    
    @discardableResult
    public func margin(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) -> StackLayout {
        self.marginLeft = left
        self.marginTop = top
        self.marginRight = right
        self.marginBottom = bottom
        return self
    }
    
    @discardableResult
    public func margin(edgeInset: SLEdgeInsets) -> StackLayout {
        self.marginLeft = edgeInset.left
        self.marginTop = edgeInset.top
        self.marginRight = edgeInset.right
        self.marginBottom = edgeInset.bottom
        return self
    }
}

extension StackLayout {
    @discardableResult
    public func align(vertial: VerticalAlignment) -> StackLayout {
        self.verticalAlignment = vertial
        return self
    }
    
    @discardableResult
    public func align(horizontal: HorizontalAlignment) -> StackLayout {
        self.horizontalAlignment = horizontal
        return self
    }
}

extension StackLayout {
    @discardableResult
    public func distribute(_ distribution: Distribution) -> StackLayout {
        self.distribution = distribution
        return self
    }
}

extension StackLayout {
    fileprivate func build() {
        
        if self.stackView != nil {
            layoutViews.forEach { (v) in
                if v.intrinsicContentSize.width != 0 && v.intrinsicContentSize.height != 0 {
                    v.isHidden = false
                } else {
                    v.isHidden = true
                }
            }
        } else {
            
            let arrangedView = layoutViews.filter { return $0.intrinsicContentSize.width != 0 && $0.intrinsicContentSize.height != 0 }
            arrangedView.forEach { $0.removeFromSuperview() }
            
            let sv = SLStackView(arrangedSubviews: arrangedView)
            sv.axis = self.orientation.toAxis
            sv.spacing = self.spacing
            sv.alignment = self.orientation == .vertical ? horizontalAlignment.toAlignment : verticalAlignment.toAlignment
            sv.distribution = self.distribution.toDistribution
            
            self.addSubview(sv)
            sv.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                sv.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: marginLeft),
                sv.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: marginRight),
                sv.topAnchor.constraint(equalTo: self.topAnchor, constant: marginTop),
                sv.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: marginBottom)
                ])
            
            self.stackView = sv
        }
    }
    
    public func update() {
        let layouts = self.layoutViews.compactMap { $0 as? StackLayoutUpdatable }
        if layouts.isEmpty {
            self.build()
        } else {
            layouts.forEach { $0.update() }
        }
    }
}
