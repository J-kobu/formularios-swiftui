//
//  SettingsView.swift
//  Formularios
//
//  Created by Jacob Aguilar on 21-01-21.
//

import SwiftUI

struct SettingsView: View {
    
    private var sortingOrders = ["Alfabéticamente",
                                 "Los favoritos al inicio",
                                 "Los comprados al inicio"
    ]
    @State private var selectedOrder = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ordenar cursos")) {
                    Picker(selection: $selectedOrder, label: Text("Ordernan  de cursos")){
                        ForEach(0..<sortingOrders.count, id: \.self) {
                            Text(self.sortingOrders[$0])
                        }
                    }
                }
                Section(header: Text("Filtrar cursos")) {
                    Text("Filtros")
                }
            }
            .navigationBarTitle("Configuración")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
