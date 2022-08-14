import Foundation

@main
struct ElementIO {

    let time: String
    
    static func main() {
        
        let time = CommandLine.arguments[1]
        print("Simulated time: \(time)")
        
        let parser = ElementIO(time: time)
        
        while let line = readLine() {
            parser.process(line: line)
        }
    }
}

// MARK: - Execution time
extension ElementIO {
    func process(line: String) {

        // Create task
        let task = parse(line)
        
        // Evaluate next run
        let next = nextRun(task)
        
        // Result
        print("Next run: \(next) | Scheduled: \(task.time.toString()) | Task: \(task.task)")
    }
    
    func nextRun(_ task: Task) -> String {
        let time = Time(time: time)
        
        var h = time.h
        var m = time.m
        
        // Minute
        if task.time.m != -1 && time.m != task.time.m {
            if time.m > task.time.m && task.time.h == -1 {
                h = time.h + 1
            }
            
            m = task.time.m
        }
        
        if task.time.m == -1 {
            
            m += 1
            
            if task.time.h != -1 && time.h != task.time.h {
                m = 0
            }
        }
        
        // Hour
        if task.time.h != -1 && time.h != task.time.h {
            h = task.time.h
        }
        
        if task.time.h == -1 && time.m >= task.time.m {
            if task.time.m != -1 {
                h = time.h + 1
            }
        }
        
        // Fix +1
        if m > 59 {
            m = m - 60
            h += 1
        }
        
        if h > 24 {
            h = 0
        }
        
        return Time(h: h, m: m).toString()
    }
}

// MARK: - Config
extension ElementIO {

    func parse(_ input: String) -> Task {
        
        let comp = input.split(separator: " ")
        
        let task = Time(h: Int(comp[1]) ?? -1, m: Int(comp[0]) ?? -1)
        
        return Task(time: task, task: String(comp[2]))
    }
}
