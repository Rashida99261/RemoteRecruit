//
//  JobRowView.swift
//  RemoteRecruit
//
//  Created by Rashida on 6/06/26.
//

import SwiftUI

struct JobRowView: View {
    let job: Job

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack(alignment: .top) {

                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 52, height: 52)
                    .overlay {
                        Text(String(job.companyName.prefix(1)))
                            .font(.headline)
                            .fontWeight(.bold)
                    }

                VStack(alignment: .leading, spacing: 4) {

                    Text(job.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    Text(job.companyName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }

            HStack {

                Label(
                    job.location,
                    systemImage: "mappin.and.ellipse"
                )

                Spacer()

                Label(
                    job.salaryDisplay,
                    systemImage: "indianrupeesign.circle"
                )
            }
            .font(.caption)

            HStack {
                JobTypeBadge(jobType: job.jobType)

                Spacer()

                Image(systemName: "clock")
                    .foregroundColor(.secondary)

                Text("Remote")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: .black.opacity(0.08),
            radius: 10,
            x: 0,
            y: 4
        )
    }
}

struct JobTypeBadge: View {
    let jobType: String

    var body: some View {
        Text(jobType.replacingOccurrences(of: "_", with: " ").capitalized)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(color.opacity(0.12))
            .foregroundColor(color)
            .clipShape(Capsule())
    }

    private var color: Color {
        switch jobType {
        case "full_time":
            return .green

        case "contract":
            return .orange

        case "part_time":
            return .blue

        default:
            return .gray
        }
    }
}

