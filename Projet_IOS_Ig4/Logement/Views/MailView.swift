//
//  MailView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 25/03/2024.
//

import Foundation
import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    var subject: String
    var recipients: [String]
    var messageBody: String

    func makeUIViewController(context: Context) -> UIViewController {
        // Check if the device can send emails
        guard MFMailComposeViewController.canSendMail() else {
            // If not, print an error or show an alert and return a dummy UIViewController
            print("Mail services are not available.")
            return UIViewController()
        }
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator
        mailComposeVC.setSubject(subject)
        mailComposeVC.setToRecipients(recipients)
        mailComposeVC.setMessageBody(messageBody, isHTML: false)
        return mailComposeVC
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(_ parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            DispatchQueue.main.async {
                self.parent.presentation.wrappedValue.dismiss()
            }
        }
    }
}

struct MailView_Previews: PreviewProvider {
    static var previews: some View {
        MailView(subject: "Feedback", recipients: ["vincentdubuc@gmail.com"], messageBody: "Hello!")
    }
}
