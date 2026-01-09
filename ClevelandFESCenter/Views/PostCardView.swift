//
//  PostCardView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/9/26.
//

import SwiftUI
import SwiftData

struct PostCardView: View {

    let post: AppPost
    let author: AppUser?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: - Author Header
            HStack(spacing: 12) {
                AvatarView(name: author?.firstName, size: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(author?.firstName ?? "Unknown") \(author?.lastName ?? "User")")
                        .font(.headline)

                    Text(post.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)

                }

                Spacer()
            }

            // MARK: - Text Content
            if let text = post.textContent, !text.isEmpty {
                Text(text)
                    .font(.body)
            }

            // MARK: - Media
            if !post.mediaIDs.isEmpty {
                PostMediaGrid(mediaIDs: post.mediaIDs)
            }

            // MARK: - Actions
            HStack(spacing: 24) {
                Label("\(post.likeCount)", systemImage: "heart")
                Label("\(post.commentCount)", systemImage: "bubble.right")
                Spacer()
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
