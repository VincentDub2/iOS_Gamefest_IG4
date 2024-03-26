import UIKit
import EventKit
import CalendarKit

final class CustomCalendarExampleController: DayViewController {
    //Example of user triggered event
    //Can be delet
    var creneaux: [Creneau] = []

    
    //Store the event generated
    var generatedEvents = [EventDescriptor]()
    
    //Set to track dates already generated to avoid duplication
    var alreadyGeneratedSet = Set<Date>()
    
    //Color for the event
    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.red]

    // Formateur pour afficher les intervalles de temps de manière lisible.
    private lazy var dateIntervalFormatter: DateIntervalFormatter = {
        let dateIntervalFormatter = DateIntervalFormatter()
        dateIntervalFormatter.dateStyle = .none
        dateIntervalFormatter.timeStyle = .short

        return dateIntervalFormatter
    }()
    
    // Configure la vue du calendrier avec le bon fuseau horaire.
    override func loadView() {
        calendar.timeZone = TimeZone(identifier: "Europe/Paris")!

        dayView = DayView(calendar: calendar)
        view = dayView
    }
    
    
    // Configure le titre, la barre de navigation, et se déplace vers le premier événement.
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Planning"
        navigationController?.navigationBar.isTranslucent = false
        dayView.autoScrollToFirstEvent = true
        
        // Récupérer les créneaux ici et les transformer en événements
        
        fetchAndPrepareCreneaux()
        reloadData()
    }

    // MARK: EventDataSource
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        if !alreadyGeneratedSet.contains(date) {
            alreadyGeneratedSet.insert(date)
            // Ajoutez ici la logique pour filtrer les créneaux basés sur la date si nécessaire
            let eventsForDate = creneaux.compactMap { transformCreneauToEvent($0) }
            generatedEvents.append(contentsOf: eventsForDate)
        }
        return generatedEvents
    }
    
    func fetchAndPrepareCreneaux() {
        PlanningService.shared.getCreneaux { [weak self] result in
            switch result {
            case .success(let creneaux):
                // Transformer les créneaux en événements et les stocker dans generatedEvents
                self?.generatedEvents = creneaux.compactMap { self?.transformCreneauToEvent($0) }
                DispatchQueue.main.async {
                    self?.reloadData()
                }
            case .failure(let error):
                print("Erreur lors de la récupération des créneaux: \(error)")
                print("voici les creneaux ")
                print(PlanningService.shared.creneau)
            }
        }
    }
    
    func transformCreneauToEvent(_ creneau: Creneau) -> Event? {
        let event = Event()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // Assurez-vous que ce format correspond à celui de vos créneaux
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Paris") // Ajustez selon le fuseau horaire des créneaux
        

        guard let start = dateFormatter.date(from: creneau.timeStart),
                  let end = dateFormatter.date(from: creneau.timeEnd),
                  start < end else {
                print("Erreur: Les dates de début et de fin sont invalides ou la date de début est après la date de fin.")
                return nil // Retourne nil si les dates ne sont pas valides
            }
            
        event.dateInterval = DateInterval(start: start.addingTimeInterval(30), end: end)
        // Personnalisez ici avec les détails de votre créneau
        event.text = creneau.name
        event.color = colors.randomElement() ?? .gray // Choisissez une couleur par défaut ou selon une logique spécifique
        event.isAllDay = false // Ou true si c'est un événement sur toute la journée
        event.lineBreakMode = .byTruncatingTail
        // event.lineBreakMode et event.userInfo peuvent être configurés si nécessaire
        
        return event
    }

    // MARK: DayViewDelegate

    private var createdEvent: EventDescriptor?
    
    
    /**
     dayViewDidSelectEventView(_ eventView: EventView) :
     Objectif : Cette fonction est appelée lorsqu'un utilisateur sélectionne un événement spécifique dans le calendrier. C'est-à-dire, lorsque l'utilisateur touche un événement affiché sur le calendrier, cette méthode est invoquée.
     Paramètre eventView : Elle prend en paramètre un EventView, qui est la vue représentant l'événement que l'utilisateur a sélectionné.
     Comportement : À l'intérieur de la fonction, il y a une tentative de récupération de descriptor comme une instance de Event à partir de eventView. Si cette récupération est réussie, cela signifie que l'événement sélectionné est valide, et on peut ensuite accéder aux informations de cet événement, comme montré par l'impression des informations de l'événement (descriptor) et de ses informations utilisateur (userInfo).
     
     */
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    // Actions pour une selection long
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        endEventEditing()
        print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
        beginEditing(event: descriptor, animated: true)
        print(Date())
    }
    
    /**
     dayView(dayView: DayView, didTapTimelineAt date: Date) :
     Objectif : Cette fonction est déclenchée lorsque l'utilisateur touche une partie quelconque de la ligne temporelle du calendrier, mais pas nécessairement un événement. Cela pourrait être utilisé pour ajouter un nouvel événement à une heure spécifique choisie par l'utilisateur.
     Paramètres : Elle prend deux paramètres : dayView, qui est la vue du calendrier jour, et date, la date et l'heure exactes où l'utilisateur a tapé sur la ligne temporelle.
     Comportement : La fonction commence par appeler endEventEditing() pour potentiellement terminer l'édition d'un événement existant, puis imprime la date exacte où l'utilisateur a tapé. Cette méthode pourrait être utilisée pour initialiser la création d'un nouvel événement à cette date précise.
     */
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
        print("Did Tap at date: \(date)")
    }
    
  
    override func dayViewDidBeginDragging(dayView: DayView) {
        endEventEditing()
        print("DayView did begin dragging")
    }

    override func dayView(dayView: DayView, willMoveTo date: Date) {
        print("DayView = \(dayView) will move to: \(date)")
    }

    override func dayView(dayView: DayView, didMoveTo date: Date) {
        print("DayView = \(dayView) did move to: \(date)")
    }

    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        print("Did long press timeline at date \(date)")
        // Cancel editing current event and start creating a new one
        endEventEditing()
        print("Creating a new event")
        //create(event: event, animated: true)
        //createdEvent = event
    }
    
    
    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        print("did finish editing \(event)")
        print("new startDate: \(event.dateInterval.start) new endDate: \(event.dateInterval.end)")

        if let _ = event.editedEvent {
            event.commitEditing()
        }

        if let createdEvent = createdEvent {
            createdEvent.editedEvent = nil
            generatedEvents.append(createdEvent)
            self.createdEvent = nil
            endEventEditing()
        }

        reloadData()
    }
}
