//
//  Copyright 2015 Google LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import GoogleMobileAds
import UIKit


class MySimpleNativeAdView: UIView {

  @IBOutlet weak var mainPlaceholder: UIView!
    @IBOutlet weak var labelText: UILabel!


  var customNativeAd: GADCustomNativeAd!


  func populate(withCustomNativeAd customNativeAd: GADCustomNativeAd) {
    self.customNativeAd = customNativeAd
    
      for subview: UIView in mainPlaceholder.subviews {
        subview.removeFromSuperview()
      }
      
      let image: UIImage? = customNativeAd.image(forKey: "Image")?.image
      mainPlaceholder.addSubview(UIImageView(image: image))
      
      let text: UILabel? = UILabel(frame: CGRect(x: 0, y: 100, width: 400, height: 100))
      text?.text = customNativeAd.string(forKey: "DestinationURL")
      text?.text?.append(" ---> DestinationURL")
      mainPlaceholder.addSubview(text!)

      let lineItemText: UILabel? = UILabel(frame: CGRect(x: 0, y: 150, width: 400, height: 100))
      lineItemText?.text = customNativeAd.string(forKey: "LineItemID")
      lineItemText?.text?.append(" ---> LineItemID")
      mainPlaceholder.addSubview(lineItemText!)
  }
}
