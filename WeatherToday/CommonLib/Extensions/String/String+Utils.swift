//
//  String+Utils.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//

import Foundation
import UIKit

public let TurkishCharsToEnglishCharsMapping: [Character: Character] = [
    "ç": "c",
    "ğ": "g",
    "ı": "i",
    "ö": "o",
    "ş": "s",
    "ü": "u",
    "Ç": "C",
    "Ğ": "G",
    "İ": "I",
    "Ö": "O",
    "Ş": "S",
    "Ü": "U"
]

public extension String {
    var searchable: String { replaceTurkishCharsToEnglishChars().lowercased() }

    func letterSpacing(_ letterSpacing: Float) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.kern: letterSpacing])
    }

    // MARK: NumberFormatted

    func numberFormatted() -> String {
        if self == "," { return "" }
        var hasDecimalCharacter = false
        var decimalPart = ""
        var absolutePart = ""
        let exceptGrouping = replacingOccurrences(of: ".", with: "")

        if exceptGrouping.contains(",") {
            hasDecimalCharacter = true
            decimalPart = (exceptGrouping.components(separatedBy: ",").last ?? "")
            absolutePart = (exceptGrouping.components(separatedBy: ",").first ?? "")
        } else {
            absolutePart = exceptGrouping
        }

        let styler = NumberFormatter()
        styler.numberStyle = .decimal
        styler.groupingSeparator = "."
        let converter = NumberFormatter()
        if let result = converter.number(from: absolutePart) {
            if let str = styler.string(from: result) {
                if hasDecimalCharacter {
                    return str + "," + decimalPart
                } else {
                    return str
                }
            }
        }
        return ""
    }

    func decimalPart() -> String {
        var decimalPart = ""
        let exceptGrouping = replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "TL", with: "")

        if exceptGrouping.contains(",") {
            decimalPart = (exceptGrouping.components(separatedBy: ",").last ?? "")
        }
        return ",\(decimalPart)"
    }

    func absolutePart() -> String {
        var absolutePart = ""
        let exceptGrouping = replacingOccurrences(of: ".", with: "")

        if exceptGrouping.contains(",") {
            absolutePart = (exceptGrouping.components(separatedBy: ",").first ?? "")
        } else {
            absolutePart = exceptGrouping
        }
        return absolutePart
    }

    func currencyInputFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        // swiftlint:disable force_try
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex
            .stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                      range: NSRange(location: 0, length: count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: double / 100)

        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }

    func removeFractionDigitsIfZero() -> String {
        var tmp = self
        if tmp.hasSuffix(",00") {
            tmp.removeLast()
            tmp.removeLast()
            tmp.removeLast()
        }
        return tmp
    }

    func alphaNumericFormatter() -> String {
        if self == "," { return "" }
        var exceptGrouping = replacingOccurrences(of: ".", with: "")
        exceptGrouping = exceptGrouping.replacingOccurrences(of: "*", with: "")
        exceptGrouping = exceptGrouping.replacingOccurrences(of: "#", with: "")
        exceptGrouping = exceptGrouping.replacingOccurrences(of: "+", with: "")
        exceptGrouping = exceptGrouping.replacingOccurrences(of: ";", with: "")

        return exceptGrouping
    }

    func image() -> UIImage? {
        guard let image = UIImage(named: self) else { return nil }
        return image
    }

    func ibanFormatted(separator _: String = " ") -> String {
        return group(by: 4, separator: " ")
    }

    func clearedIban() -> String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }

    func cardFormatted() -> String {
        return group(by: 4, separator: " ")
    }

    func group(by groupSize: Int, separator: String) -> String {
        if count <= groupSize { return self }

        let splitSize = min(max(2, count - 1), groupSize)
        let splitIndex = index(startIndex, offsetBy: splitSize)

        return "\(String(self[..<splitIndex]))\(separator)\(String(suffix(from: splitIndex)).group(by: groupSize, separator: separator))"
    }

    func isLetter() -> Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }

    func isNumber() -> Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }

    func isAlphaNumeric() -> Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    func checkTextFieldForIBAN() -> Bool {
        var tempIbanString = self
        tempIbanString = tempIbanString.replacingOccurrences(of: " ", with: "")

        if tempIbanString.count <= 26 {
            if tempIbanString.count > 2 {
                let beginWithTR = String(tempIbanString.prefix(2))
                if beginWithTR.isLetter() {
                    return true
                } else {
                    return false
                }
            } else {
                if tempIbanString.isNumber() {
                    return true
                } else {
                    return false
                }
            }
        } else {
            return false
        }
    }

    func luhnCheck() -> Bool {
        var sum = 0
        let reversedCharacters = reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch (idx % 2 == 1, digit) {
            case (true, 9): sum += 9
            case (true, 0 ... 8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }

    func truncate(length: Int, trailing: String = "…") -> String {
        return (count > length) ? prefix(length) + trailing : self
    }

    func removeVowels() -> String {
        let vowels: [Character] = ["a", "e", "i", "o", "ö", "u", "ü", "A", "E", "I", "O", "Ö", "U", "Ü"]
        let result = String(filter { !vowels.contains($0) })
        return result
    }

    var jsonStringRedecoded: String? {
        let data = ("\"" + self + "\"").data(using: .utf8)!
        do {
            if let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? String {
                return result
            }
            return self
        } catch {
            return self
        }
    }

    func replaceTurkishCharsToEnglishChars() -> String {
        return map(TurkishCharsToEnglishCharsMapping.getValueOrKey).reduce("") { $0.merge($1) }
    }

    func equalIngoreLocalizationsAndCase(to string: String?) -> Bool {
        guard let string = string else { return false }
        return replaceTurkishCharsToEnglishChars().lowercased() == string.replaceTurkishCharsToEnglishChars().lowercased()
    }

    func convertToValidFileName(regex: String = "[^a-zA-Z0-9_]+", replace: String = "") -> String {
        let fullRange = startIndex ..< endIndex
        let validName = replacingOccurrences(of: regex,
                                             with: replace,
                                             options: .regularExpression,
                                             range: fullRange)
        return validName
    }

    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }
}

public extension String {
    func hexString() -> String {
        let data = self.data(using: .utf8)!
        return data.map { String(format: "%02x", $0) }.joined()
    }

    func hexToString(uppercase _: Bool = false, prefix _: String = "", separator _: String = "") -> String? {
        guard let regex = try? NSRegularExpression(pattern: "(0x)?([0-9A-Fa-f]{2})", options: .caseInsensitive) else {
            return nil
        }
        let textNS = self as NSString
        let matchesArray = regex
            .matches(in: textNS as String, options: [], range: NSRange(location: 0, length: textNS.length))
        let characters = matchesArray.compactMap { match -> Character? in
            if let intVal = UInt32(textNS.substring(with: match.range(at: 2)), radix: 16),
               let uniCode = UnicodeScalar(intVal) {
                return Character(uniCode)
            }
            return nil
        }
        return String(characters).replacingOccurrences(of: "\0", with: "")
    }

    func split(length _: Int) -> [String] {
        return []
    }
}

public extension NSAttributedString {
    func letterSpacing(_ letterSpacing: Float) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString
            .addAttribute(NSAttributedString.Key.kern, value: letterSpacing,
                          range: NSRange(location: 0, length: attributedString.length - 1))
        return attributedString
    }
}

public extension String {
    // swiftformat:disable redundantSelf
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self
            .boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font],
                          context: nil)

        return ceil(boundingBox.height)
    }

    // swiftformat:disable redundantSelf
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self
            .boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font],
                          context: nil)

        return ceil(boundingBox.width)
    }

    func longestLine() -> String {
        return String(split(separator: "\n").sorted { $0.count > $1.count }.first ?? "")
    }

    func sizeWithMultiline(font: UIFont) -> CGSize {
        let lines = split(separator: "\n")
        var maxWidth: CGFloat = 0
        for line in lines {
            let size = String(line).size(withAttributes: [NSAttributedString.Key.font: font])
            if size.width > maxWidth {
                maxWidth = size.width
            }
        }
        return CGSize(width: maxWidth,
                      height: (font.lineHeight * CGFloat(lines.count)) + (font.leading * CGFloat(lines.count - 1)))
    }
}

public extension String {
    func encodedOffset(of character: Character) -> Int? {
        return firstIndex(of: character)?.utf16Offset(in: self)
    }

    func encodedOffset(of string: String) -> Int? {
        return range(of: string)?.lowerBound.utf16Offset(in: self)
    }
}

public extension Optional where Wrapped == String {
    var count: Int {
        guard let self = self else { return 0 }
        return self.count
    }

    var isEmpty: Bool {
        guard let self = self else { return true }
        return self.isEmpty
    }

    func encodedOffset(of character: Character) -> Int? {
        guard let self = self else { return nil }
        return self.encodedOffset(of: character)
    }

    func encodedOffset(of string: String) -> Int? {
        guard let self = self else { return nil }
        return self.encodedOffset(of: string)
    }
}
