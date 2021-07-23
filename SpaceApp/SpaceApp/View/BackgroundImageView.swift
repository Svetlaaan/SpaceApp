//
//  BackgroundImageView.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 21.07.2021.
//

import UIKit

final class BackgroundImageView: UIImageView {

    lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "space")
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.center = self.center
        return imageView
    }()
}
