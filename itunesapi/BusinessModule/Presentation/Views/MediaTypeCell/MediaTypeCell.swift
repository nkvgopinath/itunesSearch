//
//  MediaTypeCell.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//

import UIKit

class MediaTypeCell: UITableViewCell {

    static let identifier = "MediaTypeCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageSelect: UIImageView!
    
    @IBOutlet weak var lineView: UIView!

    @IBOutlet weak var mainView: UIView!

    
    var title: String?  {
        didSet{
            titleLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
