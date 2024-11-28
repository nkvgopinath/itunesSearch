//
//  ImageWithTileView.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 21/11/24.
//

import UIKit

class ImageWithTileView: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var tileLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleView: UIView!

    let nibName = "ImageWithTileView"

    var backHandler:(()->())?

    override  init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(self.nibName, owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        contentView.backgroundColor = ColorUtils.blackColor
        tileLabel.textColor = ColorUtils.whiteColor

    }
    
    @IBAction func backAction(_ sender: Any) {
        if let handler = backHandler{
            handler()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    

}
