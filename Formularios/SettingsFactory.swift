//
//  SettingsFactory.swift
//  Formularios
//
//  Created by Jacob Aguilar on 10-02-21.
//

import Foundation
import Combine //Importamos combine

final class SettingsFactory: ObservableObject { 
    
    @Published var defaults: UserDefaults //Al ser una variable de tipo Published, esta será notificada desde la clases que hagan uso de la variable defaults cuando se genere un cambio
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        defaults.register(defaults: [ //Utilizamos tuplas (Clave: valor) para indicar los valores por defecto que tendrá la app
            "app.view.settings.order": 0,
            "app.view.settings.showPurchasedOnly": false,
            "app.view.settings.maxPrice": 5
        ])
    }
    
    //Variables autocomputadas
    var order: SortingOrderType {
        get { //De esta manera aobtendríamos el valor del SortingOrderType a partir del valor guardado en defaults
            SortingOrderType(type: defaults.integer(forKey: "app.view.settings.order"))
        }
        set{
            defaults.set(newValue.rawValue, forKey: "app.view.settings.order")
        }
    }
    var showPurchasedOnly: Bool {
        get {
            defaults.bool(forKey: "app.view.settings.showPurchasedOnly")
        }
        set {
            defaults.set(newValue, forKey: "app.view.settings.showPurchasedOnly")
        }
    }
    var maxPrice: Int {
        get {
            defaults.integer(forKey: "app.view.settings.maxPrice")
        }
        set {
            defaults.set(newValue, forKey:"app.view.settings.maxPrice")
        }
        
    }
}
