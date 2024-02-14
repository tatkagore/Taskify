//
//  StyledButton.swift
//  Taskify
//
//  Created by Tatiana Simmer on 14/02/2024.
//

import Foundation
import UIKit

class StyledButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }

    private func setStyle() {

        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor(hex: "334195")
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor(hex: "334195").cgColor
        self.layer.borderWidth = 1.0
        self.titleLabel?.font = UIFont(name: "Print Clearly", size: 30)
        self.heightAnchor.constraint(equalToConstant: 40.0).isActive = true

        // Add shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
        self.layer.masksToBounds = false
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
