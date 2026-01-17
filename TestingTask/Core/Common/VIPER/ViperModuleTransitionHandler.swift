//
//  ViperModuleTransitionHandler.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit

public enum TransitionStyle {
    case push
    case pushToRoot
    case pushLeft
    case pushBottom
    case pushFade
    case modal
    case formSheet
    case modalOverCurrentContext
    case modalOverFullscreen
    case side
    case fade
}

public protocol ViperModuleTransitionHandler: class {
    func openModule(vc: UIViewController, style: TransitionStyle, completion: (() -> Swift.Void)?)
    func openModule(transitionHandler: ViperModuleTransitionHandler, style: TransitionStyle)
    func closeModule()
    func popModule()
    func popModuleLeft()
    func popModuleFade()
    func popToRootViewController()
    func popToViewController(vc: AnyClass)
    func swapAndPopToRootViewController(vc: UIViewController)
}

extension ViperModuleTransitionHandler {
    func openModule(vc: UIViewController, style: TransitionStyle, completion: (() -> Swift.Void)? = nil) {
        self.openModule(vc: vc, style: style, completion: completion)
    }
}

public extension ViperModuleTransitionHandler where Self: UIViewController {

    func openModule(vc: UIViewController, style: TransitionStyle, completion: (() -> Swift.Void)? = nil) {
        switch style {
        case .modal:
            self.present(vc, animated: true, completion: completion)
        case .modalOverCurrentContext:
            self.definesPresentationContext = true
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: {
                self.definesPresentationContext = false
            })
        case .modalOverFullscreen:
            self.definesPresentationContext = true
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.view?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.present(vc, animated: true, completion: {
                self.definesPresentationContext = false
                completion?()
            })
        case .side:
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            self.present(vc, animated: false, completion: nil)
        case .push:
            self.navigationController?.pushViewController(vc, animated: true)
            completion?()
        case .pushToRoot:
            self.navigationController?.navigationController?.pushViewController(vc, animated: true)
            completion?()
        case .pushBottom:
            let transition = CATransition()

            transition.duration = 0.5
            transition.type = .moveIn
            transition.subtype = .fromTop
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(vc, animated: true)
            completion?()
        case .pushLeft:
            let transition = CATransition()

            transition.duration = 0.5
            transition.type = .moveIn
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(vc, animated: true)
            completion?()

        case .pushFade:
            let transition = CATransition()

            transition.duration = 0.3
            transition.type = .fade
          //  transition.subtype = .fromBottom
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(vc, animated: false)
            completion?()
        case .fade:
            vc.modalTransitionStyle = .crossDissolve
            if let nc = self.navigationController {
                nc.present(vc, animated: true, completion: completion)
            } else {
                self.present(vc, animated: true, completion: completion)
            }
        case .formSheet:
            self.definesPresentationContext = true
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true, completion: {
                self.definesPresentationContext = false
                completion?()
            })

        }
    }

    func openModule(transitionHandler: ViperModuleTransitionHandler, style: TransitionStyle) {
        guard let vc = transitionHandler as? UIViewController else {
            return
        }

        switch style {
        case .modal:
            self.present(vc, animated: true, completion: nil)
        case .modalOverCurrentContext:
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .overCurrentContext
        case .modalOverFullscreen:
            self.definesPresentationContext = true
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.view?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.present(vc, animated: true, completion: {
                self.definesPresentationContext = false
            })
        case .formSheet:
            self.definesPresentationContext = true
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true, completion: {
                self.definesPresentationContext = false
            })
        case .side:
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            self.present(vc, animated: false, completion: nil)
        case .push:
            self.navigationController?.pushViewController(vc, animated: true)
        case .pushToRoot:
            self.navigationController?.navigationController?.pushViewController(vc, animated: true)
        case .pushBottom:
            let transition = CATransition()

            transition.duration = 0.5
            transition.type = .moveIn
            transition.subtype = .fromTop
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(vc, animated: true)
        case .pushLeft:
            let transition = CATransition()

            transition.duration = 0.5
            transition.type = .moveIn
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(vc, animated: true)
        case .pushFade:
            let transition = CATransition()

            transition.duration = 0.3
            transition.type = .fade
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(vc, animated: true)
        case .fade:
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)

        }
    }

    func closeModule() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    func popModule() {
        self.navigationController?.popViewController(animated: true)
    }

    func popModuleLeft() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .push
        transition.subtype = .fromRight
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)

    }

    func popModuleFade() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }

    func popToRootViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    func popToViewController(vc: AnyClass) {
        guard let viewControllers = self.navigationController?.viewControllers else {
            return
        }

        for viewController in viewControllers {
            if viewController.isKind(of: vc) {
                self.navigationController?.popToViewController(viewController,
                                                               animated: true)
                return
            }
        }
    }

    func swapAndPopToRootViewController(vc: UIViewController) {
        self.navigationController?.viewControllers = [vc]
        self.navigationController?.popToRootViewController(animated: true)
    }
}
