import Foundation

public enum LogLevel {
    /**
       Logs request and response lines.
     
        --> POST /greeting http/1.1 (3-byte body)
        <-- 200 OK (22ms, 6-byte body)
     */
    case basic
    /// Logs request and response lines and their respective headers and bodies (if present).
//    --> POST /greeting http/1.1
//    Host: example.com
//    Content-Type: plain/text
//    Content-Length: 3
//
//    Hi?
//    --> END POST
//
//    <-- 200 OK (22ms)
//    Content-Type: plain/text
//    Content-Length: 6
//
//    Hello!
//    <-- END HTTP
    case body
    /// Logs request and response lines and their respective headers.
//    --> POST /greeting http/1.1
//    Host: example.com
//    Content-Type: plain/text
//    Content-Length: 3
//    --> END POST
//
//    <-- 200 OK (22ms)
//    Content-Type: plain/text
//    Content-Length: 6
//    <-- END HTTP
    case headers
    /// no logs
    case nothing
}
