//
//  AboutViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit

final class AboutViewController: BaseViewController {

    /// Кнопка для возврата на главный экран
    private lazy var returnToMainVC: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(returnToMainPage), for: .touchUpInside)
        return button
    }()

    /// Фоновое изображение
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "space")
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.center = view.center
        return imageView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "About app"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: returnToMainVC)
        setAutoLayout()
        //		startAnimation()
    }

    private func setAutoLayout() {
        view.addSubview(backgroundImageView)
    }

//    func startAnimation() {
//
//        let textAnimation = CAKeyframeAnimation(keyPath: "position")
//        let duration = 20.0
//
//        let pathArray = [[view.frame.width / 2, view.frame.height], [view.frame.width / 2, -100]]
//        textAnimation.values = pathArray
//        textAnimation.duration = duration
//        textAnimation.repeatCount = 0
//        aboutLabel.layer.add(textAnimation, forKey: "textPosition")
//
//        Timer.scheduledTimer(timeInterval: TimeInterval(duration + 1.0),
//                             target: self,
//                             selector: #selector(contactInfo),
//                             userInfo: nil, repeats: false)
//    }

//    @objc func contactInfo() {
//        aboutLabel.isHidden = true
//        contactsImageView.isHidden = false
//    }

    @objc func returnToMainPage() {
        navigationController?.popViewController(animated: true)
    }
}
