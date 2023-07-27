//
//  MenuCode.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

enum MenuKey: String {
    case unknown = ""
    case phoneBook = "Mainpage.PhoneBook"
    case biometricAuth = "Mainpage.Biometric"
    case rotaPlus = "Mainpage.RotaPlus"
    case softOtp = "Mainpage.SoftOTP"
    case remoteWork = "Mainpage.RemoteWork"
    case myDevice = "Mainpage.Wifi"
    case scanDocument = "Mainpage.DYS"
    case beamer = "Mainpage.Beamer"
    case agenda = "Mainpage.Agenda"
    case delegation = "Mainpage.Delegation"
    case scheduledVisit = "Mainpage.Transportation"
    case leaveEntry = "Mainpage.LeaveRequest"
}

extension Menu {
    func navigate(source _: BaseDataViewController? = nil,
                  presenter presenterController: UIViewController? = nil,
                  data _: ViewModelData? = nil,
                  loggedInViaMenu _: Bool = false,
                  navigationCompletion _: (() -> Void)? = nil) {
        guard let presenterController = presenterController else { return }
        switch menuKey {
        case .unknown:
            print("unknown menu")
        case .phoneBook:
            NavigationRouter.push(from: presenterController, to: PhoneBookSearchVC(), menu: self)
        case .biometricAuth:
            NavigationRouter.present(from: presenterController, to: BiometricAuthenticationVC(), menu: self, presentationStyle: .popover)
        case .softOtp:
            if KeychainKeeper.shared.hasActivationCompleted {
                NavigationRouter.present(
                    from: presenterController,
                    to: SoftOtpGenerateVC(),
                    menu: self,
                    presentationStyle: .popover,
                    data: SoftOtpGenerateViewModelData(expiresIn: SoftOtpConstants.period)
                )
            } else {
                NavigationRouter.present(
                    from: presenterController,
                    to: PinChangeVC(),
                    menu: self,
                    presentationStyle: .popover,
                    data: PinChangeViewModelData(mode: .create)
                )
            }
        case .rotaPlus:
            NavigationRouter.push(from: presenterController, to: RotaPlusVC(), menu: self)
        case .remoteWork:
            NavigationRouter.push(from: presenterController, to: RemoteWorkVC(), menu: self)
        case .myDevice:
            NavigationRouter.present(from: presenterController,
                                     to: MyDeviceVC(),
                                     menu: self,
                                     presentationStyle: .popover)
        case .scanDocument:
            NavigationRouter.push(from: presenterController,
                                  to: ScanDocumentDashboardVC(),
                                  menu: self)
        case .beamer:
            NavigationRouter.push(from: presenterController, to: BeamerPackagesVC(), menu: self)
        case .agenda:
            NavigationRouter.present(from: presenterController,
                                     to: AgendaDashboardVC(),
                                     menu: self,
                                     presentationStyle: .popover)
        case .delegation:
            NavigationRouter.present(from: presenterController,
                                     to: DelegationPageVC(),
                                     menu: self,
                                     presentationStyle: .popover)
        case .scheduledVisit:
            NavigationRouter.push(from: presenterController, to: ScheduledVisitVC(), menu: self)
        case .leaveEntry:
            NavigationRouter.present(from: presenterController,
                                     to: LeaveEntryListVC(),
                                     menu: self,
                                     presentationStyle: .popover)
        default:
            print("no menu navigate")
        }
    }

    var menuTitle: String? {
        switch menuKey {
        case .biometricAuth:
            return PersistentKeeper.shared.biometricType.menuTitle
        default:
            return description
        }
    }
}

extension MenuKey {
    var icon: UIImage? {
        switch self {
        case .unknown:
            return nil
        case .softOtp:
            return UIImage(named: "menuSoftOtp")
        case .phoneBook:
            return UIImage(named: "blackAddressBook")
        case .biometricAuth:
            return PersistentKeeper.shared.biometricType.menuIcon
        case .rotaPlus:
            return UIImage(named: "menuRotaPlus")
        case .remoteWork:
            return UIImage(named: "blackRemote")
        case .myDevice:
            return UIImage(named: "wiFi")
        case .scanDocument:
            return UIImage(named: "scan")
        case .beamer:
            return UIImage(named: "menuBeamer")
        case .agenda:
            return UIImage(named: "notepad")
        case .delegation:
            return UIImage(named: "blackPersons")
        case .scheduledVisit:
            return UIImage(named: "blueBus")
        case .leaveEntry:
            return UIImage(named: "leaveEntry")
        }
    }
}

extension MenuKey: Codable {
    public init(from decoder: Decoder) throws {
        self = try MenuKey(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

extension BiometricType {
    var menuIcon: UIImage? {
        switch self {
        case .none:
            return nil
        case .touchID:
            return UIImage(named: "blackFinger")
        case .faceID:
            return UIImage(named: "blackFaceID")
        }
    }

    var menuTitle: String? {
        let biometricTypeStr = String(PersistentKeeper.shared.biometricType.rawValue)
        return ResourceKey.biometricActivationTitle(biometricTypeStr).value
    }
}
