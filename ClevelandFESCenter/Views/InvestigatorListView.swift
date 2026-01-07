//
//  InvestigatorListViewe.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/7/26.
//
import SwiftUI

struct InvestigatorListView: View {
    @State private var investigators: [Investigator] = []
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            List(investigators) { investigator in
                NavigationLink(destination: InvestigatorView(investigator: investigator)) {
                    VStack(alignment: .center, spacing: 8) {
                        // Image centered
                        AsyncImage(url: investigator.imageURL) { image in
                            image.resizable()
                                 .scaledToFit()
                                 .frame(height: 150)
                                 .clipShape(RoundedRectangle(cornerRadius: 12))
                        } placeholder: {
                            ProgressView()
                                .frame(height: 150)
                        }

                        // Name centered
                        Text(investigator.name)
                            .font(.headline)
                            .multilineTextAlignment(.center)

                        // Role centered
                        Text(investigator.role ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity) // Fill width for centering
                    .padding(.vertical, 8)
                }
                .listRowSeparator(.hidden) // Optional: remove separators for cleaner look
            }
            .navigationTitle("Investigators")
            .task {
                do {
                    investigators = try await InvestigatorService.shared.fetchInvestigators()
                    isLoading = false
                } catch {
                    print("Error fetching investigators:", error)
                    isLoading = false
                }
            }
        }
    }
}
