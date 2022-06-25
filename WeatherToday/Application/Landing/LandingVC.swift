//
//  LandingVC.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 6.06.2022.
//

import Foundation
import MLBase

class LandingVC: BaseVC<WeatherVM> {

    private func appendAction(actions: inout [(title: String, action: () -> Void)], titleKey: String?, rawValue: String?) -> [(title: String, action: () -> Void)] {
        if let titleKey = titleKey {
            actions.append((titleKey, {
                print("heyyyooo")
            }))
        }
        return actions
    }

    @IBAction func getWeather(_ sender: Any) {

        NavigationRouter.push(from: self,
                              to: WeatherVC(),
                              data: nil)
    }

    @IBAction func getLandingPage(_ sender: Any) {
        NavigationRouter.present(to: WeatherVC(),
                                 presentationStyle: .overFullScreen,
                                 animated: true)
    }

    @IBAction func popUp(_ sender: Any) {
//        RoutingEnum.securityQuestionInfoPopUp.navigate(isPopup: true, popupCompletion: nil, transitionStyle: .modal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
