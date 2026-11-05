//
//  NSAttributedString+Stipend.swift
//  InterFind
//

import UIKit

extension NSAttributedString {
    /// Stipend text with the amount highlighted in the accent color, e.g. "$900 / mo".
    static func stipend(_ text: String?, size: CGFloat = 14) -> NSAttributedString {
        guard let text, !text.isEmpty else {
            return NSAttributedString(string: "Unpaid", attributes: [
                .font: UIFont.systemFont(ofSize: size, weight: .medium),
                .foregroundColor: UIColor.secondaryLabel
            ])
        }
        let parts = text.components(separatedBy: " / ")
        let result = NSMutableAttributedString(string: parts[0], attributes: [
            .font: UIFont.systemFont(ofSize: size, weight: .bold),
            .foregroundColor: UIColor.accent
        ])
        if parts.count > 1 {
            result.append(NSAttributedString(string: " / " + parts[1], attributes: [
                .font: UIFont.systemFont(ofSize: size, weight: .medium),
                .foregroundColor: UIColor.label
            ]))
        }
        return result
    }
}
