//
//  ContentView.swift
//  CalendarViewSample
//
//  Created by Ryan J. W. Kim on 2022/01/11.
//

import SwiftUI
import CoreData

struct WeekCalendarView: View {
    
    @EnvironmentObject var dataController: DataController
    private let calendar: Calendar
    private let monthDayFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    
    @State private var selectedDate = Self.now
    private static var now = Date()
    @State private var selectedProjects = [Project]()
    
    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }
    
    init(calendar: Calendar, dataController: DataController) {
        self.calendar = calendar
        self.monthDayFormatter = DateFormatter(dateFormat: "MM/dd", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEEEEE", calendar: calendar)
    }
    
    var body: some View {
        VStack {
            CalendarWeekListView(
                calendar: calendar,
                date: $selectedDate,
                content: { date in
                    Button {
                        selectedDate = date
                        fetchDateProject(selectedDate: selectedDate)
                        print("Selected Date is \(selectedDate)")
                        print("Selected Project is \(selectedProjects)")
                    } label: {
                        Text("00")
                            .font(.caption)
                            .padding(.horizontal)
                            .foregroundColor(.clear)
                            .overlay(
                                Text(dayFormatter.string(from: date))
                                    .foregroundColor(
                                        calendar.isDate(date, inSameDayAs: selectedDate)
                                        ? Color.primary : calendar.isDateInToday(date) ? .blue : .gray
                                    )
                            )
                            .overlay(
                                Circle()
                                    .foregroundColor(.gray.opacity(0.4))
                                    .opacity(calendar.isDate(date, inSameDayAs: selectedDate) ? 1 : 0)
                            )
                    }
                }, header: { date in
                    Text("00")
                        .font(.caption)
                        .padding(.horizontal)
                        .foregroundColor(.clear)
                        .overlay(
                            Text(weekDayFormatter.string(from: date))
                                .font(.body)
                        )
                }, title: { date in
                    HStack {
                        Text(monthDayFormatter.string(from: selectedDate))
                            .font(.headline)
                            .padding()
                        Spacer()
                    }
                    .padding(.bottom, 6)
                }, weekSwitcher: { date in
                    Button {
                        withAnimation {
                            guard let newDate = calendar.date(byAdding: .weekOfMonth, value: -1, to: selectedDate) else { return }
                            selectedDate = newDate
                            fetchDateProject(selectedDate: selectedDate)
                        }
                    } label: {
                        Label(
                            title: { Text("Previous") },
                            icon: { Image(systemName: "chevron.left") }
                        )
                            .labelStyle(.iconOnly)
                            .padding(.horizontal)
                    }.foregroundColor(.primary)
                    Button {
                        let today = calendar.startOfDay(for: Date())
                        selectedDate = today
                        fetchDateProject(selectedDate: selectedDate)
                        print("Today is \(selectedDate)")
                    } label: {
                        ZStack {
                            Text("Today")
                                .font(.caption)
                                .clipShape(RoundedRectangle(cornerRadius: 10),style: FillStyle(eoFill: true, antialiased: true))
                            .foregroundColor(.primary)
                        }
                    }

                    Button {
                        withAnimation {
                            guard let newDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: selectedDate) else { return }
                            selectedDate = newDate
                            print(fetchDateProject(selectedDate: selectedDate).description)
                        }
                    } label: {
                        Label(
                            title: { Text("Next")},
                            icon: { Image(systemName: "chevron.right") }
                        )
                            .labelStyle(.iconOnly)
                            .padding(.horizontal)
                    }.foregroundColor(.primary)
                }
                
            )
            ScrollView(.horizontal, showsIndicators: false) {
                if !selectedProjects.isEmpty {
                    LazyHGrid(rows: projectRows) {
                        ForEach(selectedProjects) { project in
                            ProjectSummaryView(project: project)
                        } //: Loop
                    } //: LazyHGrid
                } //: If project is not empty
            } //: ScrollView
        } //: VStack
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onEnded { value in
            let horizontalAmount = value.translation.width as CGFloat
            let verticalAmount = value.translation.height as CGFloat
            if abs(horizontalAmount) > abs(verticalAmount) {
                print(horizontalAmount < 0 ? "left swipe" : "right swipe")
                if horizontalAmount < 0 {
                    withAnimation(.spring()) {
                        // swipe left
                        withAnimation {
                            guard let newDate = calendar.date(byAdding: .weekOfMonth, value: -1, to: selectedDate) else { return }
                            selectedDate = newDate
                            fetchDateProject(selectedDate: selectedDate)
                        }
                    }
                } else {
                    withAnimation(.spring()) {
                        // swipe right
                        withAnimation {
                            guard let newDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: selectedDate) else { return }
                            selectedDate = newDate
                            print(fetchDateProject(selectedDate: selectedDate).description)
                        }
                    }
                }
            } else {
                print(verticalAmount < 0 ? "up swipe" : "down swipe")
            }
        }) //: swipe left & right with animation
        .onAppear(perform: {
            fetchDateProject(selectedDate: Date(timeIntervalSinceNow: -86400))
        })
        .padding(.horizontal)
    }
    @discardableResult func fetchDateProject(selectedDate :Date) -> [Project] {
        let fetchRequest : NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dueDate >= %@ AND dueDate < %@", selectedDate as NSDate, selectedDate + 86400 as NSDate)
        do {
            selectedProjects = try dataController.container.viewContext.fetch(fetchRequest)
            return try dataController.container.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
}

struct WeekCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WeekCalendarView(calendar: Calendar(identifier: .gregorian), dataController: DataController.preview)
            .environmentObject(DataController())
    }
}

struct CalendarWeekListView<Day: View, Header: View, Title: View, WeekSwitcher: View>: View {
    private var calendar: Calendar
    @Binding private var date: Date
    private let content: (Date) -> Day
    private let header: (Date) -> Header
    private let title:(Date) -> Title
    private let weekSwitcher: (Date) -> WeekSwitcher
    
    private let daysInWeek = 7
    
    init(
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title,
        @ViewBuilder weekSwitcher: @escaping (Date) -> WeekSwitcher
    ) {
        self.calendar = calendar
        _date = date
        self.content = content
        self.header = header
        self.title = title
        self.weekSwitcher = weekSwitcher
    }
    
    var body: some View {
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()
        VStack {
            HStack {
                self.title(month)
                self.weekSwitcher(month)
            }
            HStack(spacing: 25) {
                ForEach(days.prefix(daysInWeek), id: \.self, content: header)
            }
            HStack(spacing: 25) {
                ForEach(days, id: \.self) { date in
                    content(date)
                }
            }
            Divider()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
private extension CalendarWeekListView {
    func makeDays() -> [Date] {
        guard let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: date),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: firstWeek.end - 1)
        else {
            return []
        }
        let dateInterval = DateInterval(start: firstWeek.start, end: lastWeek.end)
        
        return calendar.generateDays(for: dateInterval)
    }
}
private extension Calendar {
    func generateDays(for dateInterval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates = [dateInterval.start]
        
        enumerateDates(startingAfter: dateInterval.start, matching: components, matchingPolicy: .nextTime) { date, _, stop in
            guard let date = date else {
                return }
            guard date < dateInterval.end else {
                stop = true
                return
            }
            
            dates.append(date)
        }
        
        return dates
    }
    
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDays(for: dateInterval, matching: dateComponents([.hour, .minute, .second], from: dateInterval.start))
    }
}

private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}

private extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
        self.locale = Locale(identifier: "en_US")
    }
}
