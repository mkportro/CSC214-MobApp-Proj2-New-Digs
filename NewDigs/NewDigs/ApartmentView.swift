//
//  ApartmentView.swift
//  NewDigs
//
//  Created by MaKayla Ortega Robinson on 7/30/23.
//

import SwiftUI
import MapKit

struct ApartmentView: View {
    
    var item: Item
    @StateObject var locationVM = LocationVM()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title ?? "")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                HStack {
                    Text(formatRent(item.rent), formatter: currencyFormatter)
                        .fontWeight(.heavy)
                        .padding(.horizontal, 20)
                    Spacer()
                    Text("\(item.sqft.description) sqft")
                }
                VStack(alignment: .leading) {
                    Text("Address:")
                    Text(item.address ?? "")
                        .padding(.horizontal, 20)
                }
                VStack(alignment: .leading) {
                    Text("Phone:")
                    Text(item.phone ?? "")
                        .padding(.horizontal, 20)
                }
                VStack(alignment: .leading) {
                    Text("Notes:")
                    Text(item.notes ?? "")
                        .padding(.horizontal, 20)
                }
                VStack(alignment: .leading) {
                    Text("Map:")
                    MapView(location: locationVM.location ?? CLLocation())
                        .frame(width:300, height:250)
                        .cornerRadius(10)
//                        .disabled(!locationVM.enabled)
                }
                VStack(alignment: .leading) {
                    Text("Snapshot:")
                    if let uiImage = UIImage(data: item.image ?? Data()) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:200, height:200)
                    } else {
                        Text("")
                    }
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
        .padding(30)
    }
    
    func formatRent(_ rent: Int16) -> NSNumber {
        NSNumber(value:rent)
    }
}

private let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "en_US")
    return formatter
}()

struct ApartmentView_Previews: PreviewProvider {
    static var previews: some View {
        ApartmentView(item: Item.example)
    }
}
