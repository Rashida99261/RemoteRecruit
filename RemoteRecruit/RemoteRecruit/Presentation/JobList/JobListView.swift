//
//  JobListView.swift
//  RemoteRecruit
//
//  Created by Rashida on 6/06/26.
//

import SwiftUI

struct JobListView: View {
    @ObservedObject var viewModel: JobListViewModel


    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                SearchBar(text: $viewModel.searchText)

                Group {
                    switch viewModel.viewState {
                    case .idle, .loading:
                        LoadingView()

                    case .loaded:
                        jobList

                    case .empty:
                        EmptyStateView(
                            icon: "briefcase",
                            title: "No jobs found",
                            subtitle: "Try a different search term"
                        )

                    case .error(let message):
                        ErrorStateView(
                            message: message,
                            onRetry: viewModel.retry
                        )
                    }
                }
            }
            .navigationTitle("Remote Jobs")
            .task {
                await viewModel.loadJobs()
            }
        }
    }

    private var jobList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.jobs) { job in

                    NavigationLink {
                        JobDetailView(
                            viewModel: JobDetailViewModel(job: job)
                        )
                    } label: {
                        JobRowView(job: job)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}
