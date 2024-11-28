//
//  iTunesDescriptionController.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//

import UIKit
import AVKit
import AVFoundation

class iTunesDetailsController: UIViewController  {
    
    @IBOutlet weak var tileImageView: UIImageView!
    
    @IBOutlet weak var navigationView: NavigationBarView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var generLabel: UILabel!
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var videoView: UIView!

    
    @IBOutlet weak var playButton: UIButton!

    var player: AVPlayer?
    
    var playerLayer: AVPlayerLayer?

    
    var viewModel: iTunesViewModel?
    
        override func viewDidLoad() {
        super.viewDidLoad()
            self.basicSetup()
            
            if let selectedData = viewModel?.selectedData {
                self.bindUidata(iTunesData: selectedData)
            }
        
    }
    
    func basicSetup(){
        navigationView.titleLabel.text = "Description"
        navigationView.backHandler = {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.playButton.tintColor = ColorUtils.whiteColor
        
        self.view.backgroundColor = ColorUtils.blackColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func previewAction(_ sender: Any) {
        self.viewModel?.openWebPage()
    }
    
    @IBAction func playAction(_ sender: Any) {
       if self.player?.timeControlStatus == .playing {
            self.player?.pause()
           self.playButton.setImage(UIImage(named: "play"), for: .normal)

        }else {
            self.player?.play()
            self.playButton.setImage(UIImage(named: ""), for: .normal)

        }
    }
    
    func bindUidata(iTunesData: iTunesResult){
        let itune = iTunesData
        print(itune)
        self.titleLabel.text = iTunesData.trackName ?? ""
        self.subtitleLabel.text = iTunesData.artistName ?? ""
        self.generLabel.text = iTunesData.primaryGenreName ?? ""
        self.descriptionLabel.text = iTunesData.longDescription ?? iTunesData.shortDescription ?? ""
        
        if let imageUrlString = iTunesData.artworkUrl100 {
            ImageCacheManagement.instance.getImagefromUrl(urlImage: imageUrlString) { imagedata, cached in
                DispatchQueue.main.async {
                    if let img = imagedata {
                        self.tileImageView.image = img
                        self.tileImageView.layoutIfNeeded()
                        
                        if itune.kind == "song" || itune.kind == "podcast"  || itune.kind == "ebook" || itune.kind == "software" {
                            let imageView = UIImageView(image: img)
                            imageView.frame =   self.videoView.frame
                            imageView.contentMode = .scaleAspectFit
                            self.videoView.addSubview(imageView)

                        }
                        
                    }
                }
            }
        }
        
       
            DispatchQueue.main.async {
                if let previewUrl = itune.previewUrl {
                    guard let url = URL(string: previewUrl) else { return }
                    self.player = AVPlayer(url: url)
                    let  playerLayer = AVPlayerLayer(player: self.player)
                    playerLayer.frame = self.videoView.bounds
                    self.videoView.clipsToBounds = true
                    playerLayer.videoGravity = .resizeAspectFill
                    self.videoView.layer.addSublayer(playerLayer)
                    self.player?.play()
                    self.player?.isMuted = true
                    DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
                        self.player?.pause()
                        self.player?.isMuted = false
                    })
                }
            
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.player?.pause()
        }
       
    }

}
