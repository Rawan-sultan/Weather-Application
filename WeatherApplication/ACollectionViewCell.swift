//
//  ACollectionViewCell.swift
//  WeatherApplication
//
//  Created by 라완 💕 on 11/05/1444 AH.
//
import UIKit

class ACollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var dgree: UILabel!
    
    func settempCell(time:String, dgree:String){
        self.time.text = time
        self.dgree.text = dgree

   }
}
