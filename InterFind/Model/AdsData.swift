//
//  AdsData.swift
//  InterFind
//
//  Created by Alex Diaz on 2/11/24.
//  InterFind: ads were replaced with Big Tech internship program banners.
//

import UIKit

struct AdsData {
    let title: String
    let subtitle: String
    let startColor: UIColor
    let endColor: UIColor
    let url: String
}

extension AdsData {
    /// Official student programs. They only open the careers page in Safari.
    static let bigTechPrograms: [AdsData] = [
        AdsData(title: "Google",
                subtitle: "Student internships and programs",
                startColor: UIColor(red: 0.26, green: 0.52, blue: 0.96, alpha: 1),
                endColor: UIColor(red: 0.20, green: 0.66, blue: 0.33, alpha: 1),
                url: "https://www.google.com/about/careers/applications/students/"),
        AdsData(title: "Microsoft",
                subtitle: "Students & graduates: internships",
                startColor: UIColor(red: 0.00, green: 0.47, blue: 0.84, alpha: 1),
                endColor: UIColor(red: 0.00, green: 0.28, blue: 0.55, alpha: 1),
                url: "https://careers.microsoft.com/v2/global/en/students"),
        AdsData(title: "Apple",
                subtitle: "Student internships",
                startColor: UIColor(white: 0.20, alpha: 1),
                endColor: UIColor(white: 0.05, alpha: 1),
                url: "https://www.apple.com/careers/us/work-at-apple/students.html"),
        AdsData(title: "Amazon",
                subtitle: "University programs and internships",
                startColor: UIColor(red: 1.00, green: 0.60, blue: 0.00, alpha: 1),
                endColor: UIColor(red: 0.14, green: 0.18, blue: 0.24, alpha: 1),
                url: "https://www.amazon.jobs/content/en/career-programs/university"),
        AdsData(title: "Meta",
                subtitle: "Student programs",
                startColor: UIColor(red: 0.00, green: 0.51, blue: 0.98, alpha: 1),
                endColor: UIColor(red: 0.45, green: 0.25, blue: 0.95, alpha: 1),
                url: "https://www.metacareers.com/careerprograms/students"),
        AdsData(title: "NVIDIA",
                subtitle: "University recruiting",
                startColor: UIColor(red: 0.46, green: 0.73, blue: 0.00, alpha: 1),
                endColor: UIColor(red: 0.10, green: 0.25, blue: 0.05, alpha: 1),
                url: "https://www.nvidia.com/en-us/about-nvidia/careers/university-recruiting/")
    ]
}
