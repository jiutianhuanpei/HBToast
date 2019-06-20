//
//  HBToast.swift
//  HBProject
//
//  Created by 沈红榜 on 2019/5/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

import UIKit
import SnapKit

private var keyWindow: UIWindow {
    
    let win = UIApplication.shared.keyWindow
    
    if let w = win {
        return w
    }
    
    for w in UIApplication.shared.windows {
        if w.windowLevel == .normal {
            return w
        }
    }
    let w = UIWindow(frame: UIScreen.main.bounds)
    w.makeKeyAndVisible()
    return w
}

//private let space = 10
private let systemLblTag = 2000

public class HBToast: UIView {
    
    /// 内容与背景的边距，默认 (10, 10, 10, 10)
    public static var edgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    
    private override init(frame: CGRect) {
        
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = .clear
        addSubview(bgView)
        
        bgView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.left.greaterThanOrEqualToSuperview().offset(30)
        }
    }
    
    private static var currentSuperView: UIView!
    
    /// 显示自定义视图
    ///
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - view: 显示在哪个view上，默认为 keyWindow
    /// - Returns: toast，默认 2 秒后隐藏
    @discardableResult
    public class func toast(_ customView: UIView, in view: UIView? = nil) -> HBToast {
        
        return _show(customView, in: view, delay: nil)
    }
    
    /// 显示自定义视图
    ///
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - view: 显示在哪个view上，默认为 keyWindow
    /// - Returns: toast，一直展示，需调用 dismiss 隐藏
    @discardableResult
    public class func show(_ customView: UIView, in view: UIView? = nil) -> HBToast {
        
        return _show(customView, in: view, delay: -1)
    }
    
    /// 显示文字
    ///
    /// - Parameters:
    ///   - text: 要显示的文字
    ///   - view: 显示在哪个view上，默认为 keyWindow
    /// - Returns: toast，默认 2 秒后隐藏
    @discardableResult
    public class func toast(_ text: String, in view: UIView? = nil) -> HBToast {
        return _show(text, in: view, delay: nil)
    }
    
    /// 显示文字
    ///
    /// - Parameters:
    ///   - text: 要显示的文字
    ///   - view: 显示在哪个view上，默认为 keyWindow
    /// - Returns: toast，一直展示，需调用 dismiss 隐藏
    @discardableResult
    public class func show(_ text: String, in view: UIView? = nil) -> HBToast {
        return _show(text, in: view, delay: -1)
    }
    
    
    private var timer: Timer?
    
    /// 隐藏toast
    ///
    /// - Parameter delay: 延时几秒后隐藏, 默认0秒，立即隐藏
    /// - Returns: toast
    @discardableResult
    public func dismiss(_ delay: TimeInterval = 0) -> HBToast {
        
        timer?.invalidate()
        timer = nil
        
        if delay == 0 {
            dismissToast()
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { [weak self] _ in
                self?.dismissToast()
            })
        }
        return self
    }
    
    
    /// 隐藏toast
    ///
    /// - Parameter delay: 延时几秒后隐藏, 默认0秒，立即隐藏
    public class func dismiss(_ delay: TimeInterval = 0) {
        let toast = currentToast(in: currentSuperView)
        
        guard toast != nil else { return  }
        
        toast?.dismiss(delay)
    }
    
    /// 显示 toast 时，是否可以点击下面的视图，默认 false 不可以穿透
    public var canTouchThrough: Bool? {
        willSet {
            isUserInteractionEnabled = !(newValue ?? false)
        }
    }
    
    //    MARK:- private
    
    /// 显示自定义视图在toast上
    ///
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - view: 父视图
    ///   - delay: 隐藏延时，<0 时为一直显示, nil 时默认2秒后隐藏
    /// - Returns: toast
    @discardableResult
    private class func _show(_ customView: UIView, in view: UIView? = nil, delay: TimeInterval?) -> HBToast {
        
        let superView = view ?? keyWindow
        
        currentSuperView = superView
        
        var to = currentToast(in: superView)
        if to == nil {
            to = HBToast(frame: .zero)
        }
        
        let toast = to!
        
        for a in toast.bgView.subviews {
            a.removeFromSuperview()
        }
        
        toast.bgView.addSubview(customView)
        
        var width: CGFloat?, height: CGFloat?
        
        if customView.constraints.count == 0 {
            width = customView.frame.width
            height = customView.frame.height
        }
        
        customView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(edgeInsets.top)
            maker.left.equalToSuperview().offset(edgeInsets.left)
            maker.bottom.equalToSuperview().offset(-edgeInsets.bottom)
            maker.right.equalToSuperview().offset(-edgeInsets.right)
            
            if let w = width, let h = height {
                maker.width.equalTo(w)
                maker.height.equalTo(h)
            }
        }
        
        if let de = delay {
            toast.addSelfToSuperview(in: superView, delay: de)
        } else {
            toast.addSelfToSuperview(in: superView)
        }
        return toast
    }
    
    @discardableResult
    private class func _show(_ text: String, in view: UIView? = nil, delay: TimeInterval?) -> HBToast {
        
        let superView = view ?? keyWindow
        
        currentSuperView = superView
        
        var to = currentToast(in: superView)
        if to == nil {
            to = HBToast(frame: .zero)
        }
        
        let toast = to!
        
        var ret = false
        
        
        for v in toast.bgView.subviews {
            if let lbl = v as? UILabel  {
                if lbl.tag == systemLblTag {
                    lbl.text = text
                    ret = true
                    break
                } else {
                    print("remove Lbl: \(v)")
                    v.removeFromSuperview()
                }
            } else {
                print("remove subview: \(v)")
                v.removeFromSuperview()
            }
        }
        
        if !ret {
            toast.bgView.addSubview(toast.lbl)
            toast.lbl.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview().offset(edgeInsets.top)
                maker.left.equalToSuperview().offset(edgeInsets.left)
                maker.bottom.equalToSuperview().offset(-edgeInsets.bottom)
                maker.right.equalToSuperview().offset(-edgeInsets.right)
            }
            toast.lbl.text = text
        }
        
        if let de = delay {
            toast.addSelfToSuperview(in: superView, delay: de)
        } else {
            toast.addSelfToSuperview(in: superView)
        }
        
        return toast
    }
    
    
    @discardableResult
    private func addSelfToSuperview(in view: UIView, delay: TimeInterval = 2) -> HBToast {
        view.addSubview(self)
        self.snp.makeConstraints { (maker) in
            maker.edges.equalTo(0)
        }
        
        if delay >= 0 {
            dismiss(delay)
        }
        
        return self
    }
    
    @objc private func dismissToast() {
        
        timer?.invalidate()
        timer = nil
        
        UIView.animate(withDuration: 0.2, animations: {
            [unowned self] in
            self.bgView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.bgView.alpha = 0
        }) { (ret) in
            
            self.removeFromSuperview()
        }
    }
    
    private class func currentToast(in view: UIView) -> HBToast? {
        
        for view in view.subviews {
            if view is HBToast {
                return view as? HBToast
            }
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK:- getter
    private lazy var bgView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return v
    }()
    
    
    
    private lazy var lbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.tag = systemLblTag
        return lbl
    }()
    
    /// 背景色，default: UIColor.black.withAlphaComponent(0.3)
    public var bgViewColor: UIColor? {
        willSet {
            bgView.backgroundColor = newValue
        }
    }
    
    /// 文本的字体颜色， default: .white
    public var textColor: UIColor? {
        willSet {
            lbl.textColor = newValue
        }
    }
    
    /// 文本的字体，default: .systemFont(ofSize: 14)
    public var font: UIFont? {
        willSet {
            lbl.font = newValue
        }
    }
}

public extension HBToast {
    
    /// 显示一个 loading，一直显示，需要手动调用 dismiss
    class func showLoading() -> HBToast {
        
        let hud = UIActivityIndicatorView(style: .whiteLarge)
        let bgView: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            return v
        }()
        
        bgView.addSubview(hud)
        hud.center = bgView.center
        
        hud.startAnimating()
        return HBToast.show(bgView)
    }
}

