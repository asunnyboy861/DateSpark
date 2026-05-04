import SwiftUI

struct ContactSupportView: View {
    @State private var topic = "General"
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var feedbackService = FeedbackService(backendURL: "https://feedback-board.iocompile67692.workers.dev")

    private let topics = ["General", "Bug Report", "Feature Request", "Subscription Issue", "Other"]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Topic", selection: $topic) {
                        ForEach(topics, id: \.self) { t in
                            Text(t).tag(t)
                        }
                    }

                    TextField("Name (optional)", text: $name)

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocorrectionDisabled()
                }

                Section {
                    TextEditor(text: $message)
                        .frame(minHeight: 120)
                        .overlay(alignment: .topLeading) {
                            if message.isEmpty {
                                Text("Describe your issue or feedback...")
                                    .foregroundStyle(.tertiary)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                            }
                        }
                } header: {
                    Text("Message")
                }

                Section {
                    Button {
                        Task {
                            await feedbackService.submitFeedback(
                                topic: topic,
                                name: name.isEmpty ? nil : name,
                                email: email,
                                message: message
                            )
                        }
                    } label: {
                        if feedbackService.isSubmitting {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Submit")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(email.isEmpty || message.isEmpty || feedbackService.isSubmitting)
                }
            }
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Thank You!", isPresented: $feedbackService.showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your message has been sent. We'll get back to you soon.")
            }
            .alert("Error", isPresented: .constant(feedbackService.errorMessage != nil)) {
                Button("OK") {
                    feedbackService.errorMessage = nil
                }
            } message: {
                Text(feedbackService.errorMessage ?? "")
            }
        }
    }

    private func dismiss() {
        name = ""
        email = ""
        message = ""
        topic = "General"
    }
}

#Preview {
    ContactSupportView()
}
