//
//  ProgressService.swift
//  Westwing
//
//  Created by dbykov on 02.12.2020.
//  Copyright © 2020 Westwing Group GmbH. All rights reserved.
//

import Foundation
import UIKit

class ProgressService {

    private var hud: UIView?
    private var pendingEmergencyHideWorkItem: DispatchWorkItem?
    private let emergencyHideTimeout: DispatchTimeInterval = .seconds(10)

    class HudViewController: UIViewController {
        override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    }

    // Calculate height excluding tabbar height
    var bottomOffset: CGFloat {
        var safeAreaBottomInset: CGFloat = 0.0
        let tabbarHeight: CGFloat = 49.0
        if #available(iOS 11.0, *) {
            safeAreaBottomInset = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 // 34
        }
        let bottomOffset = tabbarHeight + safeAreaBottomInset

        return bottomOffset
    }

    lazy var progressWindow: UIWindow = {
        let window = UIWindow(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: UIScreen.main.bounds.width,
                                                 height: UIScreen.main.bounds.height-bottomOffset))
        return window
    }()

    func showWithoutDim() {
        self.show(dimming: false)
    }
    
    func showWithoutDim(timeOut: Int) {
        self.show(dimming: false, timeOut: timeOut)
    }

    func show() {
        self.show(dimming: true)
    }

    private func show(dimming: Bool = true, style: ProgressStyle = .standard, timeOut: Int = 0) {
        guard hud == nil else {
            hideProgress()
            pendingEmergencyHideWorkItem?.cancel()
            show(dimming: dimming)
            return
        }

        hud = ProgressHudView.createView(style: style)

        if let strongHud = hud {
            strongHud.frame = UIScreen.main.bounds

            progressWindow.addSubview(strongHud)

            if dimming {
                UIView.animate(withDuration: UIView.defaultAnimationDuration, animations: {
                    strongHud.backgroundColor = UIView.defaultHudBackgroundColor
                })
            }

            progressWindow.rootViewController = HudViewController()
            progressWindow.windowLevel = UIWindow.Level.statusBar + 1
            progressWindow.isHidden = false

            pendingEmergencyHideWorkItem?.cancel()

            let emergencyHideWorkItem = DispatchWorkItem(block: { [weak self] in
                self?.hide()
            })
            
            if timeOut == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + emergencyHideTimeout, execute: emergencyHideWorkItem)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(timeOut), execute: emergencyHideWorkItem)
            }
            
            pendingEmergencyHideWorkItem = emergencyHideWorkItem
        }
    }

    var isShown: Bool {
        return hud != nil
    }

    func show(style: ProgressStyle) {
        self.show(dimming: true, style: style)
    }

    func showWithoutDim(style: ProgressStyle) {
        self.show(dimming: false, style: style)
    }

    func hide() {
        guard hud?.backgroundColor != UIColor.clear else {
            hideProgress()
            return
        }
        UIView.animate(withDuration: UIView.defaultAnimationDuration, animations: {
            self.hud?.backgroundColor = UIColor.clear
        }, completion: {
            (_) in
            self.hideProgress()
        })
    }

    private func hideProgress() {
        self.hud?.removeFromSuperview()
        self.hud = nil
        progressWindow.windowLevel = UIWindow.Level(rawValue: 0)
        progressWindow.isHidden = true
        pendingEmergencyHideWorkItem?.cancel()
    }
}
