# highlights
Highlights feature in QML

Highlights simulate AI showing different information messages, configured with highlights_feed.json, which uses JSONPath for flixible data interpretation.

**Highlights script**  

Order and content of the feed bubbles is defined in the highlights script file (in the example above it is `highlights_feed.json`).   
File format - json file.   
File structure: a set of the objects describing necessary highlight bubbles for the feed.   
Currently highlights feed is limited to 50 bubbles for being showed at the same time.    

```json
{
	"feed": [
		{},
		{},
		{}
	]
}
```
An order of bubbles in the feed is defined by the sequence of the bubble descriptions in the script. 

**Highlights general settings**

Every highlights type supports next settings

```json
"settings": {
	"display": {
		"interval": 1,
		"onFirstCycle": true
	}
}
```

`display` -> `interval` defines how often this highlight type should be displayed in the feed. For example, 1 - every cycle, 3 - every third cycle.   
`display` -> `onFirstCycle` defines if highlight should be displayed during the first cycle.

**Highlight types and their settings**

Every highlight in the feed is defined by a set of settings in the script. See the full set of of the settings:

```json
{
	"COMMENT": "",
	"typeId": "",
	"id": "",
	"data": {
		"cacheBreak": false,
		"url": ""
	},
	"title": "",
	"description": "",
	"image": {
		"url": ""
	},
	"settings": {
		"display": {
			"interval": 1,
			"onFirstCycle": true
		}
	}
	"action": {
		"typeId": "",
		"payload": null
	},
	"analytics": {
		"payload": "",
		"target": ""
	}
}
```

**typeId**  

This parameter defines a set of rules for processing data for the bubble.   
Available values:
- basic
- JSONPath
- flightInfo
- fop

**basic**

Showing highlight bubble with defined title, description and image.   

 Title and description supports aliases for resolving and showing origin and destination cities: `(destination)` and `(origin)`. For example: `"title": "Explore (origin)"`.   

Basic highlight type supports click actions defined in `"action"` -> `"typeId"` node: `"destGuideDestination"` and `"destGuideOrigin"`. It opens Destination Guide with corresponding destination and origin cities.

**JSONPath**

This highlight type allows requesting data for the highlight fields via JSONPath query. It supports for `"title"`, `"description"`, `"action"` -> `"payload"` -> `"destination"`, `"analytics"` -> `"payload"` nodes.   

JSONPath highlight type supports click actions defined in `"action"` -> `"typeId"` node: `"destGuideDestination"` and `"destGuideSpot"`. It opens Destination Guide with corresponding destinations.

`"data"` -> `"url"` node supports aliases for resolving origin and destination cities: `(destination)` and `(origin)`. This helps to make a url for opening Destination Guide with corresponding destination and origin cities.

As a special case for JSONPath highlight type, get request for fetching Destination Guide's attractions may be used and showing information about them by using correct JSONPath query in `"title"` or `"description"`. Destination Guide itself supports getting attractions for every destination by id, in addition with using `(destination)` and `(origin)` aliases.

```json
{
	"COMMENT": "DG",
	"id": 77,
	"typeId": "JSONPath",
	"data": {
                "cacheBreak": false,
                "url": "$(SERVER)/fp3d_fcgi/destination-guide/v1/pois/(destination)/attractions?lang=en"
        },
	"settings": {
		"display": {
			"interval": 1,
			"onFirstCycle": true
		}
	},
	"title": "$..description",
	"description": "",
	"image": {
		"url": "$(SERVER)/$(COMMON)/download/highlights/tb_poi_green.png"
	},
	"action": {
                "typeId": "destGuideDestination",
                "payload": {
                    "destination": "$..id"
                }
	}
}
```

**flightInfo**

Showing Flight Information parameters in the feed one by one.

```json
{
	"COMMENT": "Flight Information from flight_info.xml",
	"typeId": "flightInfo",
	"id": 9,
	"image": {
		"url": "$(SERVER)/$(COMMON)/download/highlights/aircraft.png"
	},
	"settings": {
		"display": {
			"interval": 2,
			"onFirstCycle": true
		}
	},
	"action": {
		"typeId": "flightInfo",
		"payload": null
	},
	"analytics": {
		"payload": "",
		"target": ""
	}
}
```

**fop**

Showing Flying Over Places which available in the current moment and distance to them.   

Description and title of the bubble are collected automatically, there is no need to specify them in json.

Actions are also collected automatically - to open place in FOPs feature.

If you try to open the old one FOP from story mode, there is a big chance that another one will be opened, cause that one has not already exist in FOPs feature (the plane flew by that place already).

```json
{
	"COMMENT": "Getting FoP title",
	"id": 7,
	"typeId": "fop",
	"data": {
		"cacheBreak": false,
		"url": ""
	},
	"settings": {
		"display": {
			"interval": 1,
			"onFirstCycle": true
		}
	},
	"title": "",
	"description": "",
	"image": {
		"url": "$(SERVER)/$(COMMON)/download/highlights/compass.png"
	},
	"action": {
		"typeId": "fop",
		"payload": null
	}
}
```

**Analytics**

Every highlights type supports analytics defined in `"analytics"` node. `"target"` expects string value, `"payload"` is an object.

To enable analytics for the certain highlights type `"analytics"` with `"payload"` should be defined.

JSONPath highlights type resolves JSONPath queries for each parameter in `"payload"`.

basic highlights type collects automatically `"payload"` -> `"poiId"` for origin and destination bubbles.

fop highlights type collects automatically `"payload"` -> `"fopId"` for the places.
