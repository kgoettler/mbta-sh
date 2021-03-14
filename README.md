# mbta-sh

Command line utility for querying the MBTA V3 API written in Bash

## Dependencies

- `curl` (for performing calls) 
- `jq` (for pretty-printing responses)

If you have an MBTA V3 API key, it should be stored in an environment variable called
`MBTA_API_KEY`. Note that an API key is not required, however it is recommended
that you have one to avoid usage limits. Keys are available for free at
[api-v3.mbta.com](api-v3.mbta.com). 

## Usage

All of the available calls and required/optional arguments provided by the MBTA
V3 API are implemented in `mbta.sh` For more information on these, visit the
[V3 API documentation](https://api-v3.mbta.com/docs/swagger/index.html). 

Calls without the optional `id` positional argument will request a list of
entities (e.g. routes, route\_patterns, stops, etc.). Calls with an `id` will
return a single instance of an entity (e.g. route, route\_pattern, stop, etc.). 

`--filter` allows you to add filters. A field and a value to filter with must
be provided after the flag. Multiple filters can be chained together to perform
more complex queries.

`--include` allows you to specify relationships to include. A comma-separated
list of relationships must be provided after the flag. 

`--fields` allows you to specify fields to include. A comma-separated list of
relationships must be provided after the flag. 

`--page-limit` and `--page-offset`  can be used to limit the number of entities
returned. Each of these require an additional argument specifying the limit or
offset, respectively.

### Example

```bash
$ mbta.sh predictions \
    --filter route Red \
    --filter stop place-sstat \
    --include trip,vehicle \
    --fields id \
    --page-limit 1
```

### Response
```json
{
  "data": [
    {
      "attributes": {},
      "id": "prediction-47254508-70079-90",
      "relationships": {
        "route": {
          "data": {
            "id": "Red",
            "type": "route"
          }
        },
        "stop": {
          "data": {
            "id": "70079",
            "type": "stop"
          }
        },
        "trip": {
          "data": {
            "id": "47254508",
            "type": "trip"
          }
        },
        "vehicle": {
          "data": {
            "id": "R-5469A04C",
            "type": "vehicle"
          }
        }
      },
      "type": "prediction"
    }
  ],
  "included": [
    {
      "attributes": {
        "bikes_allowed": 0,
        "block_id": "S931_-4",
        "direction_id": 0,
        "headsign": "Ashmont",
        "name": "",
        "wheelchair_accessible": 1
      },
      "id": "47254508",
      "links": {
        "self": "/trips/47254508"
      },
      "relationships": {
        ...
      },
      "type": "trip"
    },
    {
      "attributes": {
        "bearing": 135,
        "current_status": "INCOMING_AT",
        "current_stop_sequence": 90,
        "direction_id": 0,
        "label": "1814",
        "latitude": 42.35449,
        "longitude": -71.0588,
        "occupancy_status": null,
        "speed": null,
        "updated_at": "2021-03-14T14:40:27-04:00"
      },
      "id": "R-5469A04C",
      "relationships": {
        ...
      },
      "type": "vehicle"
    }
  ],
  "jsonapi": {
    "version": "1.0"
  }
}
```
