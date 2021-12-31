//
//  SimpleWidget.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/29.
//

import SwiftUI
import WidgetKit

struct TodoWidgetEntryView: View {
    var entry: Provider.Entry
    //    var entry: SimpleEntry

    var body: some View {
        VStack {
            Text("Up next…")
                .font(.title)
            if let item = entry.items.first {
                Text(item.itemTitle)
            } else {
                Text("Empty!")
            }
        }
    }
}

struct SimpleTodoWidget: Widget {
    let kind: String = "TodoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Up next…")
        .description("Your top priority task.")
        .supportedFamilies([.systemSmall])
    }
}

struct SimpleWidget_Previews: PreviewProvider {
    static var previews: some View {
        TodoWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
