//
//  AddJournalView.swift
//  MindlyHealth_IOS
//
//  Created by student on 28/05/25.
//

import SwiftUI

struct AddJournalView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var journalVM: JournalViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, content
    }

    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedMood: MoodModel = MoodModel(id: "happy", description: "Happy", emoji: "😊")
    var existingJournal: JournalModel? = nil

    let moods: [MoodModel] = [
        .init(id: "happy", description: "Happy", emoji: "😊"),
        .init(id: "sad", description: "Sad", emoji: "😢"),
        .init(id: "angry", description: "Angry", emoji: "😠"),
        .init(id: "anxious", description: "Anxious", emoji: "😰")
    ]

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(existingJournal == nil ? "New Journal Entry" : "Edit Journal Entry")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.primary)
                                    
                                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        .padding(.bottom, 24)
                        
                        // Form Content
                        VStack(spacing: 24) {
                            // Title Section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Title")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                }
                                .padding(.horizontal, 24)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    TextField("What's on your mind?", text: $title)
                                        .textFieldStyle(JournalTextFieldStyle())
                                        .focused($focusedField, equals: .title)
                                        .onSubmit {
                                            focusedField = .content
                                        }
                                }
                                .padding(.horizontal, 24)
                            }
                            
                            // Mood Section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("How are you feeling?")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                }
                                .padding(.horizontal, 24)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(moods, id: \.id) { mood in
                                            MoodSelectionCard(
                                                mood: mood,
                                                isSelected: selectedMood.id == mood.id,
                                                action: {
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        selectedMood = mood
                                                    }
                                                }
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Write your thoughts")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                }
                                .padding(.horizontal, 24)
                                
                                VStack(spacing: 8) {
                                    ZStack(alignment: .topLeading) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.regularMaterial)
                                            .stroke(Color(.quaternaryLabel), lineWidth: 1)
                                            .frame(minHeight: 200)
                                        
                                        if content.isEmpty {
                                            Text("Express your thoughts, feelings, and experiences...")
                                                .foregroundStyle(.tertiary)
                                                .padding(.horizontal, 16)
                                                .padding(.top, 16)
                                                .allowsHitTesting(false)
                                        }
                                        
                                        TextEditor(text: $content)
                                            .scrollContentBackground(.hidden)
                                            .background(.clear)
                                            .focused($focusedField, equals: .content)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 12)
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        Text("\(content.count) characters")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        .padding(.bottom, 100) // Space for floating button
                    }
                }
                .frame(minHeight: geometry.size.height)
                .overlay(alignment: .bottom) {
                    // Floating Action Buttons
                    HStack(spacing: 12) {
                        Button("Cancel") {
                            focusedField = nil
                            dismiss()
                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                        .controlSize(.large)
                        
                        Button(existingJournal == nil ? "Save Journal" : "Update Journal") {
                            focusedField = nil
                            if let journal = existingJournal {
                                journalVM.updateJournal(
                                    journal,
                                    newTitle: title,
                                    newContent: content,
                                    newMood: selectedMood
                                )
                            } else {
                                journalVM.addJournal(
                                    title: title,
                                    content: content,
                                    mood: selectedMood
                                )
                            }
                            dismiss()
                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(title.isEmpty || content.isEmpty ? .gray.opacity(0.3) : .blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .controlSize(.large)
                        .disabled(title.isEmpty || content.isEmpty)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 24)
                    .padding(.bottom, max(16, geometry.safeAreaInsets.bottom))
                }
            }
            .background(.regularMaterial)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onTapGesture {
                focusedField = nil
            }
            .onAppear {
                if let journal = existingJournal {
                    title = journal.title
                    content = journal.content
                    selectedMood = journal.mood
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct JournalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.quaternaryLabel), lineWidth: 1)
            )
    }
}

struct MoodSelectionCard: View {
    let mood: MoodModel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(mood.emoji)
                    .font(.system(size: 32))
                
                Text(mood.description)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
            }
            .frame(width: 80, height: 80)
            .background(
                isSelected ?
                AnyView(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)) :
                AnyView(Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? .clear : Color(.quaternaryLabel), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .scaleEffect(isSelected ? 1.0 : 0.9)
            .shadow(color: isSelected ? .blue.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddJournalView(journalVM: JournalViewModel())
}
