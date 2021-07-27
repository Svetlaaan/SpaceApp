//
//  GradientView.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 24.07.2021.
//

import UIKit

final class GradientView: UIView {

    var startColor: UIColor = UIColor.white
    var endColor: UIColor = UIColor.white

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        (layer as? CAGradientLayer)?.colors = [startColor.cgColor, endColor.cgColor]
    }
}
