//
//  ListTableViewCell.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 21/11/24.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    static let identifier = "ListTableViewCell"
    
    @IBOutlet weak var imageTileView: ImageWithTileView!
    
    @IBOutlet weak var lableOne: UILabel!
    
    @IBOutlet weak var labelTwo: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageTileView.titleView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
