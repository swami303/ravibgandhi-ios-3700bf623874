//
//  zoomImageViewClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/17/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class zoomImageViewClass: UIViewController,UIScrollViewDelegate
{

    //MARK:- Outlet
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var scrImage: UIScrollView!
    
    var strImageUrl: String = ""
    var imageFrom: UIImage!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        img.contentMode = UIViewContentMode.scaleAspectFit
        scrImage.delegate = self
        img.sd_setImage(with: URL.init(string: strImageUrl), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload)
        scrImage.minimumZoomScale = 1.0
        scrImage.maximumZoomScale = 6.0
        //scrImage.zoomScale = 1.0
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:_ ScrollView delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return img
    }
}
