//
//  ContentView.swift
//  NewDigs
//
//  Created by MaKayla Ortega Robinson on 7/30/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var locationVM = LocationVM()

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.date, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        ApartmentView(item: item)
                    } label: {
                        HStack(alignment: .center) {
                            if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 75, height: 75)
                                    .cornerRadius(5)
                            } else {
                                Image(systemName: "house")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 75, height: 75)
                                    .foregroundColor(.gray)
                                    .padding(5)
                                    .cornerRadius(5)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(item.title ?? "")
                                Text(formatRent(item.rent), formatter: currencyFormatter)
                                HStack {
                                    Text(item.sqft.description)
                                    Text("sqft")
                                }
                            }
                            .padding(15)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button("delete") {
                        deleteAllItems()
                    }
                }
                
                ToolbarItem {
                    NavigationLink {
                        AddApartmentView()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                    .onTapGesture {
                        locationVM.toggleService()
                    }
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteAllItems() {
        withAnimation {
            items.forEach { item in
                viewContext.delete(item)
            }
        }
    }
    
    func formatRent(_ rent: Int16) -> NSNumber {
        NSNumber(value:rent)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

private let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "en_US")
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
