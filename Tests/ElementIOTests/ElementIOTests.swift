import XCTest
@testable import ElementIO

final class ElementIOTests: XCTestCase {
    
    let timeString = "11:11"
    let taskString = "30  1 run_me_daily"
    
    func testTaskFromString() throws {
        let element = ElementIO(time: timeString)
        let task = element.parse(taskString)
        XCTAssertTrue(task.time.h == 1)
        XCTAssertTrue(task.time.m == 30)
        XCTAssertTrue(task.task == "run_me_daily")
    }
    
    func testTimeFromString() throws {
        let timeFromString = Time(time: timeString)
        XCTAssertEqual(timeFromString.h, 11)
        XCTAssertEqual(timeFromString.m, 11)
    }
    
    func testTimeToString() throws {
        let time = Time(h: 11, m: 11)
        XCTAssertEqual(timeString, time.toString())
    }
    
    func testRunEveryDay() throws {
        var element = ElementIO(time: timeString)
        var task = Task(time: Time(time: "21:11"), task: "task")
        XCTAssertEqual("21:11", element.nextRun(task))
        
        element = ElementIO(time: "11:59")
        task = Task(time: Time(time: "21:11"), task: "task")
        XCTAssertNotEqual(timeString, element.nextRun(task))
    }
    
    func testRunEveryHour() throws {
        let task = Task(time: Time(time: "*:11"), task: "task")

        var element = ElementIO(time: "9:59")
        XCTAssertEqual("10:11", element.nextRun(task))
        
        element = ElementIO(time: "11:10")
        XCTAssertEqual("11:11", element.nextRun(task))
        
        element = ElementIO(time: "11:11")
        XCTAssertEqual("12:11", element.nextRun(task))

        element = ElementIO(time: "11:12")
        XCTAssertEqual("12:11", element.nextRun(task))
        
        element = ElementIO(time: "11:59")
        XCTAssertEqual("12:11", element.nextRun(task))
    }
    
    func testRunEveryHourPlusOne() throws {
        let task = Task(time: Time(time: "*:11"), task: "task")
        
        var element = ElementIO(time: "11:59")
        XCTAssertEqual("12:11", element.nextRun(task))
        
        element = ElementIO(time: "12:11")
        XCTAssertEqual("13:11", element.nextRun(task))
        
        element = ElementIO(time: "12:59")
        XCTAssertEqual("13:11", element.nextRun(task))
    }
    
    func testRunEveryMinute() throws {
        let task = Task(time: Time(time: "11:*"), task: "task")
        
        let element = ElementIO(time: "11:09")
        XCTAssertEqual("11:10", element.nextRun(task))
    }
    
    func testRunEveryMinutePlusOne() throws {
        let element = ElementIO(time: "11:59")
        let task = Task(time: Time(time: "11:*"), task: "task")
        XCTAssertEqual("12:0", element.nextRun(task))
    }
    
    func testRunEveryHourEveryMinute() throws {
        let task = Task(time: Time(time: "*:*"), task: "task")

        let element = ElementIO(time: "11:11")
        XCTAssertEqual("11:12", element.nextRun(task))
    }
    
    func testRunEveryHourEveryMinutePlusOne() throws {
        let element = ElementIO(time: "11:59")
        let task = Task(time: Time(time: "*:*"), task: "task")
        XCTAssertEqual("12:0", element.nextRun(task))
    }
}
