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

class ViewController: UIViewController {

  /// The view that holds the native ad.
  @IBOutlet weak var nativeAdPlaceholder: UIView!


  /// The ad loader. You must keep a strong reference to the GADAdLoader during the ad loading
  /// process.
  var adLoader: GADAdLoader!

  /// The native ad view that is being presented.
  var nativeAdView: UIView!

  /// Indicates whether the Google Mobile Ads SDK has started.
  private var isMobileAdsStartCalled = false

  /// The ad unit ID.
  let adUnitID = "/21674584190/sanalmarketanasayfafreebannerios"

  /// The native custom format id
  let nativeCustomFormatId = "12119130"

  override func viewDidLoad() {
    super.viewDidLoad()
      startGoogleMobileAdsSDK()
  }

  private func startGoogleMobileAdsSDK() {
    DispatchQueue.main.async {
      guard !self.isMobileAdsStartCalled else { return }

      self.isMobileAdsStartCalled = true

      // Initialize the Google Mobile Ads SDK.
      GADMobileAds.sharedInstance().start()
      // Request an ad.
      self.refreshAd(nil)
    }
  }

  func setAdView(_ view: UIView) {
    nativeAdView?.removeFromSuperview()
    nativeAdView = view
    nativeAdPlaceholder.addSubview(nativeAdView)
    nativeAdView.translatesAutoresizingMaskIntoConstraints = false

    // Layout constraints for positioning the native ad view to stretch the entire width and height
    // of the nativeAdPlaceholder.
    let viewDictionary = ["_nativeAdView": nativeAdView!]
    self.view.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|[_nativeAdView]|",
        options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
    )
    self.view.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:|[_nativeAdView]|",
        options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
    )
  }

  // MARK: - Actions

  /// Refreshes the native ad.
  @IBAction func refreshAd(_ sender: AnyObject!) {
    var adTypes = [GADAdLoaderAdType]()
      adTypes.append(.customNative)
      adLoader = GADAdLoader(
        adUnitID: adUnitID, rootViewController: self,
        adTypes: adTypes, options: [])
      adLoader.delegate = self
        let request = GADRequest()
        request.customTargeting = ["test" : "test"];
      adLoader.load(request)
  }
}

// MARK: - GADAdLoaderDelegate

extension ViewController: GADAdLoaderDelegate {

  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    print("\(adLoader) failed with error: \(error.localizedDescription)")
  }
}



// MARK: - GADCustomNativeAdLoaderDelegate

extension ViewController: GADCustomNativeAdLoaderDelegate {
  func customNativeAdFormatIDs(for adLoader: GADAdLoader) -> [String] {
    return [nativeCustomFormatId]
  }

  func adLoader(
    _ adLoader: GADAdLoader,
    didReceive customNativeAd: GADCustomNativeAd
  ) {
      print("DestinationURL: \(customNativeAd.string(forKey: "DestinationURL"))")
      print("LineItemID: \(customNativeAd.string(forKey: "LineItemID"))")
      print("Image: \(customNativeAd.image(forKey: "Image")?.imageURL)")
    // Create and place the ad in the view hierarchy.
    let customNativeAdView =
      Bundle.main.loadNibNamed(
        "SimpleCustomNativeAdView", owner: nil, options: nil)!.first as! MySimpleNativeAdView
    setAdView(customNativeAdView)
      

 
    // Populate the custom native ad view with the custom native ad assets.
    customNativeAdView.populate(withCustomNativeAd: customNativeAd)
    // Impressions for custom native ads must be manually tracked. If this is not called,
    // videos will also not be played.
    customNativeAd.recordImpression()
  }
}
