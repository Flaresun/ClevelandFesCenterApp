//
//  InvestigatorView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//
import SwiftUI

struct InvestigatorView: View {
    let investigator: Investigator
    @State private var isExpanded: Bool = false

    var body: some View {
        ScrollView { // So content can scroll if needed
            VStack(alignment: .center, spacing: 16) {
                
                // Image on top
                AsyncImage(url: investigator.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                        .frame(width: 200, height: 200)
                }
                
                // Name and role
                Text(investigator.name)
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text(investigator.role ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Contact & info
                VStack(spacing: 4) {
                    Text("Email: \(investigator.email ?? "N/A")").font(.caption)
                    Text("Phone: \(investigator.number ?? "N/A")").font(.caption)
                    Text("Location: \(investigator.location ?? "N/A")").font(.caption)
                    Text("Project Stage: \(investigator.projectStage ?? "N/A")").font(.caption)
                }
                
                // Expandable Description
                VStack(alignment: .leading, spacing: 4) {
                    Text("Description")
                        .font(.headline)
                    
                    if isExpanded {
                        Text(investigator.description)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text(investigator.description)
                            .font(.body)
                            .lineLimit(3)
                            .truncationMode(.tail)
                    }
                    
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        Text(isExpanded ? "Show Less" : "Read More")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Investigator")
        .navigationBarTitleDisplayMode(.inline)
    }
}
