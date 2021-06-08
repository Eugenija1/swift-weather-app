import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView(.vertical){
            VStack {
                ForEach(viewModel.records){record in
                    WeatherRecordView(record1: record, viewModel1:viewModel)
            }
            }.padding()
        }
  }
}
struct Place: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

struct WeatherRecordView: View{
    let CELL_HEIGHT :CGFloat = 50
    let CORNER_RADIUS :CGFloat = 20.0
    let WEATHER_ICON_SCALE :CGFloat = 0.8
    let VSTACK_X_OFFSET: CGFloat = -20
    var record: WeatherModel.WeatherRecord
    var viewModel: WeatherViewModel
    @State private var region : MKCoordinateRegion
        //MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.0, longitude:20.0), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    @State private var showingSheet: Bool = false
    @State private var places: [Place]
        //[Place(coordinate: .init(latitude: 50.0, longitude: 20.0))]
    
    init(record1: WeatherModel.WeatherRecord, viewModel1: WeatherViewModel) {
        record = record1
        viewModel = viewModel1
        _region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: record.latt, longitude: record.long), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
        _places = State(initialValue: [Place(coordinate: .init(latitude: record.latt, longitude: record.long))])
    }
    
    //struct SheetView {
   //     @State var region: MKCoordinateRegion
    //    @State
    //}
    
    var body: some View{
        
        ZStack{
            RoundedRectangle(cornerRadius: CORNER_RADIUS).stroke()
            HStack{
                GeometryReader{ geometry in
                    Text(record.icon)
                    .font(.system(size: WEATHER_ICON_SCALE * geometry.size.height))
                    .frame(alignment: .leading)
                    .padding(.leading, 5)
                }
                VStack(alignment: .leading){
                    Text(record.cityName)
                    Text("Temperature:\(record.temperature, specifier: "%.1f")'C")
                        .font(.caption)
                }
                .offset(x: VSTACK_X_OFFSET)
                .frame(width: 120.0)
                
            
                Text("🔄")
                    .font(.largeTitle)
                    .onTapGesture{
                        viewModel.refresh(record: record)
                    }
                    .frame(alignment: .trailing)
                    //.padding(.trailing, 10)
                
                Text("🔎")
                    .font(.largeTitle)
                    .onTapGesture{
                        setCoordinates(latt: record.latt, long: record.long)
                        showingSheet = true
                        }
                    .sheet(isPresented: $showingSheet, content:{
                        VStack{
                            Text("\(record.cityName)")
                        
                       Map(coordinateRegion: $region,annotationItems: places )
                            {place in MapPin(coordinate: place.coordinate)}
                        .onAppear(perform: {setCoordinates(latt: record.latt, long: record.long)})
                            
                    }
                    //.sheet(isPresented: $showingSheet){
                    //    SheetView(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: record.latt ?? 20.0, longitude: record.long ?? 50.0), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)))
                    //}
            })
                    .frame(alignment: .trailing)
                    .padding(.trailing, 5)
            }
        }
        .frame(height: CELL_HEIGHT)
        //using .frame modifier to set height of element
      
    }
    func setCoordinates(latt: Double, long: Double){
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latt, longitude: long), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        print(region.center)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
