//
//  TodoWidget.swift
//  TodoWidget
//
//  Created by Ryan J. W. Kim on 2021/12/28.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), item: [Item.example])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), item: loadItems())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date(), item: loadItems())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    func loadItems() -> [Item] {
        let dataController = DataController()
        let itemRequest = dataController.fetchRequestForTopItems(count: 1)
        return dataController.result(for: itemRequest)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let item: [Item]
}

struct TodoWidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        VStack {
            Text("Up next...")
                .font(.title)
            if let item = entry.item.first {
                Text(item.itemTitle)
            } else {
                Text("Empty!")
            }
        }
    }
}

@main
struct TodoWidget: Widget {
    let kind: String = "TodoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct TodoWidget_Previews: PreviewProvider {
    static var previews: some View {
        TodoWidgetEntryView(entry: SimpleEntry(date: Date(), item: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
