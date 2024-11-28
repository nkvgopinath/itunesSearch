//
//  GridCollectionCell.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 21/11/24.
//

import UIKit

class GridCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var holderView: ImageWithTileView!
    
    static var identifier:String = "GridCollectionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(){
       
    }
}
