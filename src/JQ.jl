module JQ

using jq_jll
using JSON

export jqrunner, jqstr, jqparse, jqhelp

const JQArgs = Union{String,Vector{String},Cmd}
const JQInput = Union{IO,Dict{String,Any},Vector}
const JQOutput = Union{IO,Function}

to_cmd(cmd::Cmd) = cmd
to_cmd(cmd::Vector{String}) = Cmd(cmd)
to_cmd(cmd::String) = Cmd([cmd])

to_input_io(io::IO) = io
function to_input_io(json::Union{Dict{String,Any},Vector})
    pb = PipeBuffer()
    JSON.print(pb, json)
    pb
end

"""
    jqpipeline(args::Cmd; jqpath=`$(JQ.jq(identity))`, kwargs...)

Similar to `pipeline`, but specific to `jq`.
Returns a pipeline constructed with `jq` at `jqpath` passing the specified `args`.
All remaining keyword args (`kwargs`) are passed on to the underlying `pipeline` method.
"""
function jqpipeline(args::JQArgs; jqpath=`$(JQ.jq(identity))`, kwargs...)
    cmdargs = to_cmd(args)
    pipeline(`$jqpath $cmdargs`; kwargs...)
end

"""
    jqrunner(args; output=PipeBuffer())

Returns a function that encodes a `jq` command to execute.
The function can then be used repeatedly with different inputs.
It returns the output `IO` that the results were piped to.

- `args`: The `jq` filter, e.g. `".data[0]"`
- `output`: The output `IO` to stream the results to. An `IOBuffer` by default.
"""
function jqrunner(args::JQArgs; output::IO=PipeBuffer(), kwargs...)
    function chained_cmd(input::JQInput=stdin)
        jq() do jqpath
            Base.run(jqpipeline(args; jqpath=jqpath, stdin=to_input_io(input), stdout=output, kwargs...))
        end
        output
    end
end

"""
Print jq standard help.
"""
jqhelp(; output::JQOutput=stdout, kwargs...) = (jqrunner(`-h`; output=output, kwargs...))(devnull)

"""
Convert output of jq command into string.
"""
jqstr(io::IOBuffer) = String(strip(String(take!(io))))

"""
Parse output of jq command as JSON
"""
jqparse(io::IOBuffer) = JSON.parse(io)

end # module