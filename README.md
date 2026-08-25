# realgazeta
api for realgazeta.com.ua Thoughts, stories and ideas.
# main
```swift
import Foundation
import realgazeta
let client = Realgazeta()

do {
    let content = try await client.getContent(contentPath: "authors/slug/sofiia/")
    print(content)
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swift run
```
