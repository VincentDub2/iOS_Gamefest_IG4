import UIKit
import EventKit
import CalendarKit

final class CustomCalendarExampleController: DayViewController {
    //Example of user triggered event
    //Can be delet
    var data = [["Zone 4",
                 "New York, 5th avenue"],

                ["Workout",
                 "Tufteparken"],

                ["Meeting with Alex",
                 "Home",
                 "Oslo, Tjuvholmen"],

                ["Beach Volleyball",
                 "Ipanema Beach",
                 "Rio De Janeiro"],

                ["WWDC",
                 "Moscone West Convention Center",
                 "747 Howard St"],

                ["Google I/O",
                 "Shoreline Amphitheatre",
                 "One Amphitheatre Parkway"],

                ["✈️️ to Svalbard ❄️️❄️️❄️️❤️️",
                 "Oslo Gardermoen"],

                ["💻📲 Developing CalendarKit",
                 "🌍 Worldwide"],

                ["Software Development Lecture",
                 "Mikpoli MB310",
                 "Craig Federighi"],

    ]
    
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
        reloadData()
    }

    // MARK: EventDataSource
    
    // Détermine les événements à afficher pour une date donnée.
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        if !alreadyGeneratedSet.contains(date) {
            alreadyGeneratedSet.insert(date)
            generatedEvents.append(contentsOf: generateEventsForDate(date))
        }
        return generatedEvents
    }
    
    // Crée aléatoirement un ensemble d'événements pour une date spécifique
    // Can be delete
    private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
        var workingDate = Calendar.current.date(byAdding: .hour, value: Int.random(in: 1...15), to: date)!
        var events = [Event]()

        for i in 0...4 {
            let event = Event()

            let duration = Int.random(in: 60 ... 160)
            event.dateInterval = DateInterval(start: workingDate, duration: TimeInterval(duration * 60))

            var info = data.randomElement() ?? []

            let timezone = dayView.calendar.timeZone
            print(timezone)

            info.append(dateIntervalFormatter.string(from: event.dateInterval.start, to: event.dateInterval.end))
            event.text = info.reduce("", {$0 + $1 + "\n"})
            event.color = colors.randomElement() ?? .red
            event.isAllDay = Bool.random()
            event.lineBreakMode = .byTruncatingTail

            events.append(event)

            let nextOffset = Int.random(in: 40 ... 250)
            workingDate = Calendar.current.date(byAdding: .minute, value: nextOffset, to: workingDate)!
            event.userInfo = String(i)
        }

        print("Events for \(date)")
        return events
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
        let event = generateEventNearDate(date)
        print("Creating a new event")
        create(event: event, animated: true)
        createdEvent = event
    }
    
    
    // Génère un nouvel événement près d'une date spécifiée.
    private func generateEventNearDate(_ date: Date) -> EventDescriptor {
        let duration = (60...220).randomElement()!
        let startDate = Calendar.current.date(byAdding: .minute, value: -Int(Double(duration) / 2), to: date)!
        let event = Event()

        event.dateInterval = DateInterval(start: startDate, duration: TimeInterval(duration * 60))

        var info = data.randomElement()!

        info.append(dateIntervalFormatter.string(from: event.dateInterval)!)
        event.text = info.reduce("", {$0 + $1 + "\n"})
        event.color = colors.randomElement()!
        event.editedEvent = event

        return event
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
