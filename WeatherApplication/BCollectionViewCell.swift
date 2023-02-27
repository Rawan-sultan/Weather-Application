//
//  BCollectionViewCell.swift
//  WeatherApplication
//
//  Created by 라완 💕 on 11/05/1444 AH.
//

import UIKit

class BCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var day: UILabel!
    
    @IBOutlet weak var theWeather: UILabel!
    
    @IBOutlet weak var min: UILabel!
    
    @IBOutlet weak var max: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    func settempCell(day:String, theWeather:String, min:String, max:String, image:UIImage){

        self.day.text = day
        self.theWeather.text = theWeather
        self.image.image = image
        self.min.text = min
        self.max.text = max

   }
}
