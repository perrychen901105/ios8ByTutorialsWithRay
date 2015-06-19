//
//  CityTableViewCell.swift
//  WorldWeather
//
//  Created by PerryChen on 6/19/15.
//  Copyright (c) 2015 RayWenderlich. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    // MARK: - Properties
    var cityWeather: CityWeather? {
        didSet {
            configureCell()
        }
    }
    
    // MARK: - Utility methods
    private func configureCell() {
        cityImageView.image = cityWeather?.cityImage
        cityNameLabel.text = cityWeather?.name
    }

}
