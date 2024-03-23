//
//  FAQView.swift
//  Projet_IOS_Ig4
//
//  Created by Lucas Leroy on 23/03/2024.
//

import SwiftUI

// La structure pour représenter une question et sa réponse.
struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct FAQView: View {
    @State private var searchQuery = ""
    @State private var faqItems: [FAQItem] = [
        FAQItem(question: "Q : Qu'est-ce que Stary ?",
                answer: "A : Stary est une application conçue pour faciliter la gestion des bénévoles lors du festival des jeux de Montpellier..."),
              
        FAQItem(question: "Q : Comment puis-je m'inscrire en tant que bénévole pour le festival des jeux de Montpellier ?",
                answer: "A : Pour vous inscrire en tant que bénévole, vous devez télécharger l'application Stary depuis l'App Store ou Google Play Store..."),
               
        FAQItem(question: "Q : Comment puis-je consulter mon planning en tant que bénévole ?",
                answer: "A : Une fois connecté à votre compte bénévole sur l'application Stary, vous pouvez accéder à votre planning..."),
        FAQItem(question: "Q : Comment puis-je faire une demande de logement pendant l'événement ?",
                answer: "A : Si vous avez besoin d'un logement pendant le festival, vous pouvez le demander via l'application Stary..."),
        FAQItem(question: "Q : Puis-je demander un régime alimentaire spécifique pendant le festival ?",
                answer: "A : Oui, vous pouvez faire une demande de régime alimentaire spécifique pendant le festival via l'application Stary..."),
        FAQItem(question: "Q : Que faire si j'ai besoin d'aide supplémentaire ou si j'ai d'autres questions ?",
                answer: "A : Si vous avez besoin d'aide supplémentaire ou si vous avez d'autres questions, vous pouvez accéder à la section 'Besoin d'aide' de l'application Stary..."),
    ]

    @State private var expandedID: UUID?

        var filteredFAQItems: [FAQItem] {
            searchQuery.isEmpty ? faqItems : faqItems.filter {
                $0.question.lowercased().contains(searchQuery.lowercased()) ||
                $0.answer.lowercased().contains(searchQuery.lowercased())
            }
        }

        var body: some View {
            NavigationView {
                List(filteredFAQItems) { item in
                    FAQItemRow(item: item, expandedID: $expandedID)
                }
                .searchable(text: $searchQuery, prompt: "Rechercher une question")
                .navigationBarTitle("FAQ", displayMode: .inline)
            }
        }
    }

    struct FAQItemRow: View {
        let item: FAQItem
        @Binding var expandedID: UUID?

        var body: some View {
            DisclosureGroup(
                isExpanded: Binding(
                    get: { expandedID == item.id },
                    set: { isExpanded in expandedID = isExpanded ? item.id : nil }
                ),
                content: {
                    Text(item.answer)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(UIColor.systemGroupedBackground))
                },
                label: {
                    Text(item.question)
                }
            )
        }
    }

    struct FAQView_Previews: PreviewProvider {
        static var previews: some View {
            FAQView()
        }
    }
