//
//  NibLoadableView.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 6.06.2022.
//

import UIKit

public protocol NibLoadableView {
    var nibName: String { get }
    func attachToNib() -> UIView
}

public extension NibLoadableView where Self: UIView {
    var nibName: String {
        return String(describing: type(of: self))
    }

    @discardableResult
    func attachToNib() -> UIView {
        let view = loadViewFromNib()
        view.frame = bounds
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        return view
    }

    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            assertionFailure("view not created, please check file names")
            return UIView(frame: .zero)
        }
        return view
    }

    static func instance<T>() -> T? {
        let view = UINib(nibName: String(
            describing: self
        ), bundle: nil).instantiate(withOwner: self, options: nil)[0] as? T
        return view
    }
}

open class BaseNibLoadableView: UIView, NibLoadableView {
    public private(set) var view: UIView?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    @discardableResult
    open func initView() -> UIView {
        view = attachToNib()
        backgroundColor = .clear
        return view.required()
    }
}

open class BaseNibLoadableControl: UIControl, NibLoadableView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    @discardableResult
    open func initView() -> UIView {
        let view = attachToNib()
        backgroundColor = .clear
        return view
    }
}
