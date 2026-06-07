//
//  JobDetailView.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import SwiftUI

struct JobDetailView: View {
    @ObservedObject var viewModel: JobDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                headerCard

                tagsSection

                quickInfoRow

                infoGrid

                descriptionCard

                Color.clear
                    .frame(height: 90)
            }
            .padding()
        }
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            applyButton
        }
    }
}

// MARK: - Header Card
extension JobDetailView {

    private var headerCard: some View {
        HStack(alignment: .top, spacing: 16) {

            Circle()
                .fill(Color.accentColor.opacity(0.15))
                .frame(width: 64, height: 64)
                .overlay {
                    Text(String(viewModel.job.companyName.prefix(1)))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                }

            VStack(alignment: .leading, spacing: 8) {

                Text(viewModel.job.title)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(viewModel.job.companyName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                JobTypeBadge(
                    jobType: viewModel.job.jobType
                )
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: Tags
    @ViewBuilder
    private var tagsSection: some View {
        if !viewModel.job.tags.isEmpty {

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {

                    ForEach(viewModel.job.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Color.accentColor.opacity(0.12)
                            )
                            .foregroundStyle(Color.accentColor)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }

    // MARK: Quick Info
    private var quickInfoRow: some View {
        HStack {

            Label(
                viewModel.job.location,
                systemImage: "mappin.and.ellipse"
            )

            Spacer()

            Label(
                viewModel.job.salaryDisplay,
                systemImage: "banknote"
            )
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    // MARK: Grid
    private var infoGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 12
        ) {

            InfoCard(
                icon: "mappin.and.ellipse",
                title: "Location",
                value: viewModel.job.location
            )

            InfoCard(
                icon: "banknote",
                title: "Salary",
                value: viewModel.job.salaryDisplay
            )

            InfoCard(
                icon: "briefcase.fill",
                title: "Job Type",
                value: viewModel.job.jobTypeDisplay
            )

            InfoCard(
                icon: "calendar",
                title: "Posted",
                value: viewModel.formattedDate
            )
        }
    }

    // MARK: Description
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("About the Role")
                .font(.headline)

            Text(viewModel.formattedDescription)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: Apply Button
    private var applyButton: some View {
        VStack {

            Link(
                destination: URL(
                    string: viewModel.job.url
                ) ?? URL(string: "https://remotive.com")!
            ) {

                HStack {
                    Text("Apply Now")

                    Image(
                        systemName: "arrow.up.right.square"
                    )
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}

// MARK: - Info Card

struct InfoCard: View {

    let icon: String
    let title: String
    let value: String

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.accentColor)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 110,
            alignment: .topLeading
        )
        .padding()
        .background(Color(.systemGray6))
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}
