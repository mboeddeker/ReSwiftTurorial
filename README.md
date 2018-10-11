
# Redux Pattern in Swift mit ReSwift



Redux in Swift? Redux ist doch eine JavaScript Library und dieses ganze JS Zeug wollen wir doch nicht in eine iOS App einbauen oder? 
Nun Redux ist mehr ein Designpattern und Architekturentscheidung, als eine einfache Bibliothek.

Das größte Problem bei dem standard MVC Pattern sind massige ViewController, die gerne mal ins Endlose reichen. Die Testbarkeit ist fürn Arsch, ebenso die Übersicht über das ganze Projekt. Dann haben wir noch den viel zu oft kopierten Code um wieder und wieder die gleichen Dinge auszuführen etc pp.

Natürlich gibt es da unzählige Möglichkeiten (wie immer) dieses Problem zu lösen. Da ich nicht nur in einer iOS Swift Blase lebe, sondern auch Apps mit React Native baue oder auch React.js nutze für Webprojekte, kenne ich natürlich das Prinzip von Redux.

Eine kleine Erläuterung, weshalb man eigentlich sich die Mühe machte, sich das Redux Prinzip zu überlegen:

In React ist es so, dass eine App in Komponenten aufgebaut ist. Damit diese Komponenten auch untereinander sprechen können, musste man zu Beginn Daten durchreichen, als Beispiel: Komponente A lädt Daten aus dem Netz, Komponente B bekommt diese Daten und reicht diese durch bis Komponente C usw. Bei kleinen Projekten vielleicht kein Problem, aber sobald es nur etwas größer wird, will man dies so einfach nicht mehr machen. Eine andere Lösung musste her, also warum nicht einen Zentralen ‘Store’ der meine Daten verwaltet und auf diesen kann dann jede Komponente zugreifen, Daten ändern usw. Nun diese Form der Erläuterung ist stark zusammengefasst, aber ich denke das Grundprinzip wird einem klar. Lösung dafür, Flux, aus Flux wurde Redux. Da dieses Tool und die daraus resultierende Designentscheidung so beliebt geworden ist, war es ja nur eine Frage der Zeit, bis auch für andere Plattformen eine ähnliche Lösung gebaut wurde.

Also kommen wir zu ReSwift!

ReSwift hilft euch, eure App in drei grundsätzliche Strukturen aufzuteilen:

**State & Store**
Der State ist letztendlich ein Status, eurer Daten. Simples Beispiel, ein Counter. Im State haben wir eine Property namens ‘value’ oder auch ‘aktuellerZählStatus’, wie ihr möchtet. ViewController A kann dann den aktuellen Status lesen, Controller B, View Y etc pp. 
Das macht es gleich auch einfacher zu testen, da wir einen State haben mit den verschiedenen Werten. Damit dieser auch wirklich gelesen werden kann, nutzen wir unseren Store, der Store speichert den State.

**Views**
In ReSwift werden unsere Views aktualisiert, wenn der State sich verändert. Sprich Views sind der direkte Spiegel für unseren State. Beispiel hier wäre ein Label, welches mit den aktuellen Zählstatus anzeigt. Sobald sich der State verändert, verändern wir auch das Label.

**State Changes**
Um den State zu verändern, müssen wir Actions benutzen. Actions sind letztendlich kleine Beschreibungen, wie sich unsere Daten verändern sollen. Ob wir hoch zählen möchten oder hinunter, einen Reset durchführen möchten etc.
Wie schon gesagt, Actions beschreiben nur, was passieren soll, die Ausführung dessen übernehmen sogenannte ‘Reducer’. Keine Ahnung warum man sich diesen Namen dafür überlegt hat. Ich verstehe es bis heute nicht. Aber das soll nicht das Thema sein. Also der Reducer, schaut sich an, welche Action ausgeführt werden soll und verändert darauf hin dann den State.

![](https://cdn-images-1.medium.com/max/4000/1*xAa8C3AfQNDjgrH0IQ4HhQ.png)

In der Theorie klingt dies am Anfang vielleicht etwas verwirrend, das ist aber auch total in Ordnung. Am besten sind eh immer Beispiele 👍

Stellen wir uns vor, wir haben ein Bankkonto. Verstanden? Okay, super!
Wir möchten auf dieses Konto Geld einzahlen und abheben. 
Ja. Also das ist der ganze Trick bei der Geschichte. Fangen wir an. 👨‍💻

**Schritt 1 : Installation
**Xcode öffnen, SingleView Application auswählen und Projekt erstellen lassen. Dann das Terminal im Projekt Ordner öffnen und CocoaPods initialisieren.

    pod init

Dann das Podfile öffnen und ReSwift hinzufügen. Speichern nicht vergessen.

    use_frameworks!
    
    source 'https://github.com/CocoaPods/Specs.git'
    platform :ios, '8.0'
    
    pod 'ReSwift'

Installieren und danach <Appname>.xcworkspace öffnen.

    pod install && open <YOUPROJECTNAME>.xcworkspace

**Schritt 2: The App State** 🌟
In unserem Projekt ist der State erst einmal recht simpel. Also, auf unserem Bankkonto haben wir Geld, das soll erst einmal reichen.

    struct AppState: StateType {  
     var money: Float = 0.0
    }

Voila, unser AppState ist fertig. Wir könnten hier natürlich noch viel mehr Properties anlegen oder auch Funktionen, je nachdem was benötigt wird.

**Schritt 3: Actions** 🔧
Actions sind letztendlich auch wieder Structs oder Klassen, die von dem ReSwift Typen Action erben. Erstellen wir einfach mal zwei, einmal um Geld einzuzahlen und Geld abzuheben.

    struct IncreaseMoney: Action {
     var value: Float

     init(value: Float) {
      self.value = value
     }
    }

    struct DecreaseMoney: Action {
     var value: Float

     init(value: Float) {
      self.value = value
     }
    }

Die value die wir in die Actions mit angelegt haben, nutzen wir dann, um zu definieren, wie viel Geld wir vom Konto holen oder einzahlen möchten.

**Schritt 4: Reducer** 👷‍
Der Reducer, ich definiere diesen jetzt einfach mal männlich, von mir aus aber auch die Reducerin, ist der, der am Ende die Arbeit ausführt und unseren State verändert. Laut ReSwift müssen wir nur eine Funktion hinzufügen, aber zur Übersicht und der Tatsache, das man nicht immer nur einen Reducer benötigt in größeren Projekten, habe ich eine Klasse angelegt, na ja ihr werdet es ja sehen.

    struct Reducers {

     func moneyReducer(action: Action, state: AppState?) -> AppState {
       var state = state ?? AppState()

       switch action {
       case let action as IncreaseMoney:
         state.money += action.value
       case let action as DecreaseMoney:
         state.money -= action.value
       default:
         return state
       }

       return state
     }
    }

Also was passiert hier nun genau? Ein Reducer ist wie folgt aufgebaut:
 name(action, oldstate) -> newstate 
Wir geben also eine Action und den State mit, der verändert werden soll, anhand der Action verändern wir die jeweiligen Werte des States. Wenn die Arbeit erledigt ist, geben wir den veränderten State zurück.

Dieses Beispiel ist natürlich echt super simpel, wir könnten aber auch Rest API Calls ausführen oder oder oder. Man könnte jetzt fragen, weshalb wir den Funktionsparameter state optional gesetzt haben. Das hat den Grund, dass am Ende der Store (dazu kommen wir gleich) den AppState übergibt, dieser am Anfang natürlich leer ist und falls dies wirklich so sein sollte, erstellen wir im Reducer kurzerhand einen.

**Schritt 5: Der Store** 💾
Jetzt kommen wir zum letzten Teil unserer Vorbereitungen (ja ich weiß, viel Boilerplate möchte man meinen, aber es lohnt sich wirklich) und erstellen unseren Store. Wenn wir wollten, könnten wir einfach eine Konstante irgendwo im Projekt anlegen und dort unseren Store definieren, das wäre aber nicht unbedingt ‘best practise’. Also erstellen wir eine Klasse, ich habe diese mal MainStore genannt, habe daraus eine Singleton Instanz gemacht und geben dort meinen Store zurück. Warum ein Singleton? Wir benötigen eine Instanz, die nicht immer wieder und wieder neu initialisiert wird und dadurch ihre Werte verliert. Eigentlich logisch oder?

    class MainStore {
      
      // Singleton Instance
      static let shared = MainStore()
      
      internal var reducers: Reducers
      public var store: Store<AppState>

      init() {
       self.reducers = Reducers()
       self.store = Store<AppState>(reducer: reducers.moneyReducer, state: nil)
      }
    }

Diesen Store können wir nun im jeden ViewController, anderen Klassen etc pp aufrufen und auf den State zugreifen. Also geht es nun zum letzten Schritt und wir implementieren das ganze in unseren ViewController.

**Schritt 6: Trinke den Wein deiner Trauben** 🍷🍇
Öffnet nun das Storyboard und legt einfach ein Label und zwei Buttons an. Titel von Button 1 ist ‘Add 100’, Titel von Button 2 ‘Remove 20’. Outlets und Actions setzen, fertig.

    class ViewController: UIViewController, StoreSubscriber {

      @IBOutlet weak var label: UILabel!
      var store: Store<AppState>?

      @IBAction func addHundred(_ sender: Any) {
        let action = IncreaseMoney(value: 100.0)
        store?.dispatch(action)
      }

      @IBAction func removeTwenty(_ sender: Any) {
        let action = DecreaseMoney(value: 20.0)
        store?.dispatch(action)
      }

      override func viewDidLoad() {
        super.viewDidLoad()
        self.store = MainStore.shared.store
      }

      override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store?.subscribe(self)
      }

      override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store?.unsubscribe(self)
      }

      // MARK: - StoreSubscriberDelegate
      func newState(state: AppState) {
        label.text = "Money: \(state.money)"
      }
    }

Gehen wir einmal diesen ViewController durch. Wir erweitern unseren Controller um das StoreSubscriber Protokoll. Dadurch haben wir die tolle Möglichkeit unsere Funktion func newState(state: StateType) zu nutzen. Hier spielt sich dann letztendlich die ‘Magie’ ab. Immer wenn wir Daten in unserem State verändern, wird diese Funktion aufgerufen und unsere Daten aktualisiert. Damit dies auch wirklich funktioniert, muss unser ViewController subscribed werden. Dies machen wir am besten in der viewDidAppear und unsubscribe in der viewWillDisappear . Denkt wirklich daran, sobald euer Controller nicht mehr relevant ist und auf die Daten angewiesen, sollte er wirklich sein ‘Abo’ beenden. Sonst kommt es zu Memoryleaks etc pp usw. Halt unschön und so der bessere Weg.

Das war jetzt mal ein simples Beispiel. Probiert es einmal aus, mir gefällt es wirklich ganz gut und ihr könnt sehr nett eure Projekte etwas aufräumen. Wenn ich noch einmal Zeit finden sollte, mache ich noch einen Artikel über das Zusammenspiel von RxSwift und ReSwift, ich denke das könnte noch ganz spannend sein.

Natürlich habe ich dieses Projekt für euch auch auf [Github](https://github.com/mboeddeker/ReSwiftTurorial) gestellt.
