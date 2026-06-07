//
//  JobDetailViewModel.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class JobDetailViewModel: ObservableObject {
    
    let job: Job

    var formattedDescription: AttributedString {
        guard
            let data = job.description.data(using: .utf8),
            let attributedString = try? NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html
                ],
                documentAttributes: nil
            )
        else {
            return AttributedString(job.description)
        }

        return AttributedString(attributedString)
    }

    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: job.publishedAt) else { return job.publishedAt }
        return date.formatted(date: .abbreviated, time: .omitted)
    }

    init(job: Job) {
        self.job = job
    }
}
