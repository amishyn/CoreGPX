//
//  GPXRoot.swift
//  GPXKit
//
//  Created by Vincent on 5/11/18.
//  

import Foundation

open class GPXRoot: GPXElement {

    public var version: String? = "1.1"
    public var creator: String?
    public var metadata: GPXMetadata?
    public var waypoints: ContiguousArray<GPXWaypoint> = []
    public var routes: ContiguousArray<GPXRoute> = []
    public var tracks: ContiguousArray<GPXTrack> = []
    public var extensions: GPXExtensions?
    
    // MARK:- Instance
    
    public required init() {
        super.init()
        
        creator = "OSS Project"
        
    }
    
    public init(creator: String) {
        super.init()
        self.creator = creator
    }
    
    // MARK:- Public Methods
    
    var schema: String {
        return "http://www.topografix.com/GPX/1/1"
    }
    
    var schemaLocation: String {
        return "http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd"
    }
    
    var xsi: String {
        return "http://www.w3.org/2001/XMLSchema-instance"
    }
    
    public func newWaypointWith(latitude: Double, longitude: Double) -> GPXWaypoint {
        //let waypoint = GPXWaypoint().waypoint(With: latitude, longitude: longitude)
        let waypoint = GPXWaypoint.init(latitude: latitude, longitude: longitude)
        
        self.add(waypoint: waypoint)
        
        return waypoint
    }
    
    public func add(waypoint: GPXWaypoint?) {
        if let validWaypoint = waypoint {
           self.waypoints.append(validWaypoint)
        }
    }
    
    public func add(waypoints: ContiguousArray<GPXWaypoint>) {
        self.waypoints.append(contentsOf: waypoints)
    }
    
    public func remove(waypoint: GPXWaypoint) {
        let contains = waypoints.contains(waypoint)
        if contains == true {
            waypoint.parent = nil
            if let index = waypoints.firstIndex(of: waypoint) {
                self.waypoints.remove(at: index)
            }
        }
    }
    
    public func newRoute() -> GPXRoute {
        let route = GPXRoute()
        
        self.add(route: route)
        
        return route
    }
    
    public func add(route: GPXRoute?) {
        if let validRoute = route {
           self.routes.append(validRoute)
        }
    }
    
    public func add(routes: ContiguousArray<GPXRoute>) {
        self.routes.append(contentsOf: routes)
    }

    
    public func remove(route: GPXRoute) {
        let contains = routes.contains(route)
        if contains == true {
            route.parent = nil
            if let index = routes.firstIndex(of: route) {
                self.waypoints.remove(at: index)
            }
        }
    }
    
    public func newTrack() -> GPXTrack {
        let track = GPXTrack()
        
        return track
    }
    
    public func add(track: GPXTrack?) {
        if let validTrack = track {
            self.tracks.append(validTrack)
        }
    }
    
    public func add(tracks: ContiguousArray<GPXTrack>) {
        self.tracks.append(contentsOf: tracks)
    }
    
    public func remove(track: GPXTrack) {
        let contains = tracks.contains(track)
        if contains == true {
            track.parent = nil
            if let index = tracks.firstIndex(of: track) {
               self.waypoints.remove(at: index)
            }
        }
    }
    
    // MARK:- Tag
    
    override func tagName() -> String! {
        return "gpx"
    }
    
    // MARK:- GPX
    override func addOpenTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        
        let attribute: NSMutableString = ""
        
        attribute.appendFormat(" xmlns:xsi=\"%@\"", self.xsi)
        attribute.appendFormat(" xmlns=\"%@\"", self.schema)
        attribute.appendFormat(" xsi:schemaLocation=\"%@\"", self.schemaLocation)
        
        if self.version != nil {
            attribute.appendFormat(" version=\"%@\"", self.version!)
        }
        
        if self.creator != nil {
            attribute.appendFormat(" creator=\"%@\"", self.creator!)
        }
        
        gpx.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n")
        
        gpx.appendFormat("%@<%@%@>\r\n", self.indent(forIndentationLevel: indentationLevel), self.tagName(), attribute)
        
    }
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        
        if self.metadata != nil {
            self.metadata?.gpx(gpx, indentationLevel: indentationLevel)
        }
        
        for waypoint in waypoints {
            waypoint.gpx(gpx, indentationLevel: indentationLevel)
        }
        
        for route in routes {
            route.gpx(gpx, indentationLevel: indentationLevel)
        }
        
        for track in tracks {
            track.gpx(gpx, indentationLevel: indentationLevel)
        }
        
        if self.extensions != nil {
            self.extensions?.gpx(gpx, indentationLevel: indentationLevel)
        }
 
    }
}

