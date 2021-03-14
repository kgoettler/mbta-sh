# mbta-sh

Command line utility for querying the MBTA V3 API written in Bash

## Usage

All of the available calls and required/optional arguments provided by the MBTA
V3 API are implemented in `mbta.sh` For more information on these, visit the
[V3 API documentation](https://api-v3.mbta.com/docs/swagger/index.html). A
brief description of how to structure your queries with `mbta.sh` is provided
below.


### Without id

Calling `mbta.sh` without the `id` argument will request a list of entities
(e.g. routes, route\_patterns, stops, etc.). Usually these are performed with
filters, and some calls explicitly require certain filters to return any
results.

Filters are added with the `--filter` flag. A field and a value to filter with
must be provided after the flag. Multiple filters can be chained together to
perform more complex queries:

```bash
$ mbta.sh predictions --filter route Red

$ mbta.sh predictions --filter route Red --filter stop place-sstat
```

Includes and fields are added in much the same way with the `--include` and
`--fields` flag, respectively. A comma-separated list of relationships (or fields)
to include must be provided after the flag.

```bash
$ mbta.sh predictions --filter route Red --filter stop place-sstat --include trip,vehicle

$ mbta.sh predictions --filter route Red --filter stop place-sstat --include trip,vehicle --fields id
```

### With id

Calling `mbta.sh` with the `id` positional argument will return a single
instance of an entity (e.g. route, route\_pattern, stop, etc.).

```bash
$ mbta.sh routes Red --include route_patterns

$ mbta.sh route_patterns Red-3-1 --include representative_trip
```
