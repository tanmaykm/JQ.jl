# JQ.jl

[![Build Status](https://github.com/tanmaykm/JQ.jl/workflows/CI/badge.svg)](https://github.com/tanmaykm/JQ.jl/actions?query=workflow%3ACI+branch%3Amaster)
[![Coverage Status](https://coveralls.io/repos/tanmaykm/JQ.jl/badge.svg?branch=master)](https://coveralls.io/r/tanmaykm/JQ.jl?branch=master)
[![codecov.io](http://codecov.io/github/tanmaykm/JQ.jl/coverage.svg?branch=master)](http://codecov.io/github/tanmaykm/JQ.jl?branch=master)

> "jq is like sed for JSON data - you can use it to slice and filter and map and transform structured data with the same ease that sed, awk, grep and friends let you play with text".

JQ.jl is a minimalistic Julia wrapper over [jq](https://stedolan.github.io/jq/).

It provides the following methods:

### `jqrunner`

`jqrunner(args; output=PipeBuffer())`

- `args`: The `jq` filter, e.g. `".data[0]"`. The args can also contain chained filters, e.g. ".data | select(.year == 2019) | .name".
- `output`: The output `IO` to stream the results to. An `IOBuffer` by default.

Returns a function that encodes a `jq` command to execute. The function can then be used repeatedly with different inputs. It returns the output `IO` that the results were piped to. The returned function takes one argument which is the input JSON. It can be in parsed form as a `Dict` or `Vector` or can be a raw `IO`. Raw `IO` inputs will be processed in streaming fashion until EOF.

### `jqstr`

`jqstr(output)`

Converts and returns the output of a `jq` command as a String.

### `jqparse`

`jqparse(output)`

Parses the output of `jq` command as a JSON and returns the resulting `Dict` or `Array` representation.
