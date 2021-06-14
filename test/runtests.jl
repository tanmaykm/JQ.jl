using JQ
using Test
using JSON

@testset "JQ" begin
    maths_test_dataset_file = joinpath(@__DIR__, "sample_math_test_results.json")
    maths_test_dataset_url = "https://data.cityofnewyork.us/api/views/7yig-nj52/rows.json?accessType=DOWNLOAD"
    # "https://data.cityofnewyork.us/api/views/7vy4-ats6/rows.json?accessType=DOWNLOAD"
    isfile(maths_test_dataset_file) || download(maths_test_dataset_url, maths_test_dataset_file)
    maths_test_dataset = JSON.parsefile(maths_test_dataset_file)

    attr_jqr = jqrunner(".meta.view.attributionLink")
    colname_jqr = jqrunner("[.meta.view.columns[].name]")
    yearselect_jqr = jqrunner("[.data[] | select(.[10]==\"2008\") | .[10]]")
    yearcount_jqr = jqrunner("length")

    @test jqstr(attr_jqr(maths_test_dataset)) == "\"http://schools.nyc.gov/NR/rdonlyres/3E439D63-A14E-4B6E-B019-B634A8915D71/0/DistrictMathResults20062012Public.xlsx\""

    column_names = jqparse(colname_jqr(maths_test_dataset))
    @test column_names == [
        "sid",
        "id",
        "position",
        "created_at",
        "created_meta",
        "updated_at",
        "updated_meta",
        "meta",
        "District",
        "Grade",
        "Year",
        "Demographic",
        "Number Tested",
        "Mean Scale Score",
        "Num Level 1",
        "Pct Level 1",
        "Num Level 2",
        "Pct Level 2",
        "Num Level 3",
        "Pct Level 3",
        "Num Level 4",
        "Pct Level 4",
        "Num Level 3 and 4",
        "Pct Level 3 and 4"
    ]

    @test Set(jqparse(yearselect_jqr(maths_test_dataset))) == Set(["2008"])

    @test parse(Int, jqstr(yearcount_jqr(column_names))) == length(column_names)
end