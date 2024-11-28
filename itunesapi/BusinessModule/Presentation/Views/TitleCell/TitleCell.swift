//
//  TitleCell.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//

import UIKit

class TitleCell: UICollectionViewCell {

    static let identifier = "TitleCell"
    
    @IBOutlet weak var titleLable: UILabel!
    
    var title: String? {
        didSet {
            titleLable.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLable.textColor = UIColor.white
    }

}
