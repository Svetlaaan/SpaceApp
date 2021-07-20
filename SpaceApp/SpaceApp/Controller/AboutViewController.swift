//
//  AboutViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit

final class AboutViewController: BaseViewController {

	private lazy var backgroundImageView: UIImageView = {
		let image = UIImage(named: "space")
		let imageView = UIImageView(frame: view.bounds)
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.image = image
		imageView.center = view.center
		return imageView
	}()

	private lazy var aboutLabel: UILabel = {
		let label = UILabel()
		label.text = """
Odio contentiones sed cu, usu commodo prompta prodesset id. Vivendum dignissim conceptam pri ut, ei vel partem audiam sapientem. Vel in dicant cetero phaedrum, usu populo interesset cu, eum ea facer nostrum pericula. Tation delenit percipitur at vix. Ius dicat feugiat no, vix cu modo dicat principes.
		Vel in dicant cetero phaedrum, usu populo interesset cu, eum ea facer nostrum pericula. Nec labore cetero theophrastus no, ei vero facer veritus nec. Ius dicat feugiat no, vix cu modo dicat principes. Eam id posse dictas voluptua, veniam laoreet oportere no mea, quis regione suscipiantur mea an.
  Magna copiosae apeirian ius at. Vel in dicant cetero phaedrum, usu populo interesset cu, eum ea facer nostrum pericula. Nec labore cetero theophrastus no, ei vero facer veritus nec. Eu eam dolores lobortis percipitur, quo te equidem deleniti disputando. . Sale liber et vel.
"""
		label.numberOfLines = .max
		label.textColor = .white
		label.textAlignment = .justified
		label.font = UIFont.boldSystemFont(ofSize: 18)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var contactsImageView: UIImageView = {
		let image = UIImage(named: "contacts")
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFit
		imageView.center = view.center
		imageView.isHidden = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "About app"
		setAutoLayout()
		startAnimation()
	}

	private func setAutoLayout() {
		view.addSubview(backgroundImageView)

		backgroundImageView.addSubview(aboutLabel)
		let aboutLabelConstraints = ([
			aboutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			aboutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			aboutLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
		])

		backgroundImageView.addSubview(contactsImageView)
		let contactsImageViewConstraints = ([
			contactsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			contactsImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			contactsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			contactsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
		])

		NSLayoutConstraint.activate(aboutLabelConstraints)
		NSLayoutConstraint.activate(contactsImageViewConstraints)
	}

	func startAnimation() {
		aboutLabel.layer.removeAllAnimations()

		let textAnimation = CAKeyframeAnimation(keyPath: "position")
		let duration = 20.0

		let pathArray = [[view.frame.width / 2, view.frame.height], [view.frame.width / 2, -100]]
		textAnimation.values = pathArray
		textAnimation.duration = duration
		textAnimation.repeatCount = 0
		aboutLabel.layer.add(textAnimation, forKey: "textPosition")

		Timer.scheduledTimer(timeInterval: TimeInterval(duration + 2.0), target: self, selector: #selector(contactInfo), userInfo: nil, repeats: false)
	}

	@objc func contactInfo() {
		aboutLabel.isHidden = true
		contactsImageView.isHidden = false
	}
}
