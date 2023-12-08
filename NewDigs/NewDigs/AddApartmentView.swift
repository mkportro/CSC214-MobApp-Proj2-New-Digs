//
//  AddApartmentView.swift
//  NewDigs
//
//  Created by MaKayla Ortega Robinson on 7/30/23.
//

/*
 listing, rent, sqft, address, phone, notes, image gallery, save button
 */

import SwiftUI
import CoreLocation

struct AddApartmentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @State private var address = ""
    @State private var date = Date()
    @State private var id = UUID()
    @State private var image = Data()
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    @State private var title = ""
    @State private var notes = ""
    @State private var phone = ""
    @State private var rent = 0
    @State private var sqft = 0
    @State private var uiImage: UIImage? = nil
    @State private var imagePickerPresenting = false
        
    var body: some View {
        Form {
            Section("Listing") {
                TextField("Title", text: $title)
            }
            Section("Rent") {
                TextField("Rent", value: $rent, formatter: NumberFormatter())
            }
            Section("sq ft") {
                TextField("sq ft", value: $sqft, formatter: NumberFormatter())
            }
            Section("Address") {
                TextField("Address", text: $address)
            }
            Section("Phone") {
                TextField("Phone", text: $phone)
            }
            Section("Notes") {
                TextField("Notes", text: $notes)
            }
            Section("Images") {
                Button(action: {
                    imagePickerPresenting.toggle()
                }, label: {
                    Text("addImg")
                })
            }
            Section {
                Button(action: {
                    addApartment()
                    dismiss()
                }, label: {
                    Text("Save")
                }
                )
            }
        }
        .sheet(isPresented: $imagePickerPresenting) {
            PhotoPicker(image: $uiImage)
        }
    }
    
    private func addImage() {
        withAnimation {
            let imgData = Item(context: viewContext)
            imgData.id = UUID()
            
            if let data = uiImage?.jpegData(compressionQuality: 0.8) {
                imgData.image = data
            }
            
            do {
                try viewContext.save()
                dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func addApartment() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.address = address
            newItem.date = Date()
            newItem.id = UUID()
//            newItem.image = Data()
            newItem.latitude = Double(latitude)
            newItem.longitude = Double(longitude)
            newItem.title = title
            newItem.notes = notes
            newItem.phone = phone
            newItem.rent = Int16(rent)
            newItem.sqft = Int16(sqft)
            
            if let data = uiImage?.jpegData(compressionQuality: 0.8) {
                newItem.image = data
            }

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

}

struct AddApartmentView_Previews: PreviewProvider {
    static var previews: some View {
        AddApartmentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
