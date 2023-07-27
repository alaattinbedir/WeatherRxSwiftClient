//
//  UITableView+Extensions.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) {
        let name = String(describing: type).components(separatedBy: ".")[0]
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueCell<T: UITableViewCell>(_: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier,
                                             for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}
