//
//  CreatePostView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/9/26.
//
import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @AppStorage("currentUserID") private var currentUserID: String?
    @Environment(\.dismiss) private var dismiss
    @State private var postTitle: String = ""
    @State private var postText: String = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var previewImages: [UIImage] = []
    @State private var isPosting: Bool = false
    @State private var errorMessage: String?

    // Callback to update feed immediately
    var onPostCreated: ((AppPost) -> Void)?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                // Text content
                TextEditor(text: $postText)
                    .frame(height: 150)
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                
                // Photo Picker
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 5,
                    matching: .images,
                    label: { Text("Select Images / GIFs") }
                )
                .onChange(of: selectedItems) { _ in loadPreviewImages() }

                // Preview images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(previewImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                }
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Spacer()
                
                // Post button
                Button(action: createPost) {
                    if isPosting {
                        ProgressView()
                    } else {
                        Text("Post")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .disabled(isPosting || (postText.isEmpty && selectedItems.isEmpty))
            }
            .padding()
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Load Preview Images
    private func loadPreviewImages() {
        previewImages.removeAll()
        for item in selectedItems {
            Task {
                do {
                    if let data = try await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        await MainActor.run { previewImages.append(uiImage) }
                    }
                } catch {
                    print("Failed to load preview image:", error)
                }
            }
        }
    }

    // MARK: - Create Post
    private func createPost() {
        guard let userUUID = currentUserID else { return }
        isPosting = true
        errorMessage = nil

        Task {
            do {
                // Upload media
                var mediaIDs: [Int] = []
                for item in selectedItems {
                    do {
                        let id = try await UserPostService.shared.uploadMedia(item: item)
                        mediaIDs.append(id)
                    } catch {
                        print("❌ Failed to upload media:", error)
                    }
                }
                
                print("📄 Media IDs:", mediaIDs)
                
                // Create the post
                let newPost = try await UserPostService.shared.createPost(
                    authorUUID: userUUID,
                    text: postText,
                    mediaIDs: mediaIDs
                )
                
                // Update feed immediately
                await MainActor.run {
                    isPosting = false
                    onPostCreated?(newPost)
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isPosting = false
                    errorMessage = "Failed to create post: \(error.localizedDescription)"
                    print("❌ Create post error:", error)
                }
            }
        }
    }
}
