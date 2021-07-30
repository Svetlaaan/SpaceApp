//
//  BaseViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit

class BaseViewController: UIViewController {

    private let spinner = SpinnerViewController()

    var isLoading = false {
        didSet {
            guard oldValue != isLoading else { return }
            let isShown = showSpinner(isShown: isLoading)
            NSLog("Spinner status - \(isShown)")
        }
    }

    func showSpinner(isShown: Bool) -> Bool {
        if isShown {
            addChild(spinner)
            spinner.view.frame = view.frame
            view.addSubview(spinner.view)
            spinner.didMove(toParent: self)
            return true
        } else {
            spinner.willMove(toParent: nil)
            spinner.view.removeFromSuperview()
            spinner.removeFromParent()
            return false
        }
    }
}
